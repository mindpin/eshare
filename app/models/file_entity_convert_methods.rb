module FileEntityConvertMethods
  class ConvertStatus
    CONVERTING = 'CONVERTING'
    SUCCESS  = "SUCCESS"
    FAILURE  = "FAILURE"
    QUEUE_DOWN = "QUEUE_DOWN"
  end

  def self.included(base)
    base.after_save :convert_enqueue_if_needed
  end

  def convert_enqueue_if_needed
    return true if !uploaded?
    return true if !need_convert?
    return true if !convert_ready?
    convert_enqueue
  end

  def need_convert?
    self.is_ppt? ||
    self.extname == 'pdf' ||
    self.extname == 'doc'
  end

  def convert_ready?
    self.convert_status.blank?
  end

  def convert_success?
    self.convert_status == ConvertStatus::SUCCESS
  end

  def converting?
    self.convert_status == ConvertStatus::CONVERTING
  end

  def convert_failure?
    self.convert_status == ConvertStatus::FAILURE
  end

  def convert_queue_down?
    self.convert_status == ConvertStatus::QUEUE_DOWN
  end

  def convert_enqueue
    if MindpinWorker.sidekiq_running?
      self.convert_status = ConvertStatus::CONVERTING
      self.save
      CourseWareConverter.perform_async(self.id)      
    else
      self.convert_status = ConvertStatus::QUEUE_DOWN
      self.save
    end
  rescue Redis::CannotConnectError
    convert_failed!
  end

  def convert_success!
    self.convert_status = ConvertStatus::SUCCESS
    self.save
  end

  def convert_failed!
    self.convert_status = ConvertStatus::FAILURE
    self.save
  end

  def convert_output_dir
    File.join(R::CONVERT_BASE_PATH, "/convert_#{extname}/file_entities/#{self.id}")
  end

  def output_base_url
    "/convert_#{extname}/file_entities/#{self.id}"
  end

  def saved_name
    File.basename(saved_file_name, ".#{extname}")
  end

  def doc_images
    output_images
  end

  def pdf_images
    output_images
  end

  def ppt_images
    output_images
  end

  def output_images
    match_path = File.join(convert_output_dir,"*.png")
    Dir[match_path].map{|path| OutputImage.new(path, output_base_url)}.sort_by(&:id)
  end

  class OutputImage
    attr_reader :id, :url, :name
    def initialize(path, base_url)
      @name = File.basename(path)
      @id = @name.match(/_(\d*).png/)[1].to_i
      @url = File.join(base_url, @name)
    end
  end
end
