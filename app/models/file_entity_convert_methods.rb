module FileEntityConvertMethods
  class ConvertStatus
    CONVERTING = 'CONVERTING'
    SUCCESS  = "SUCCESS"
    FAILURE  = "FAILURE"
    QUEUE_DOWN = "QUEUE_DOWN"
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

  def convert_enqueue
    return if converting? || convert_success?

    if PPTConverter.sidekiq_running?
      self.convert_status = ConvertStatus::CONVERTING
      self.save
      PPTConverter.perform_async(self.id)      
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

  def convert_ppt_output_dir
    File.join(R::CONVERT_BASE_PATH, "/convert_ppt/file_entities/#{self.id}")
  end

  def convert_ppt_output_index_html
    File.join(convert_ppt_output_dir,'index.html')
  end

  def ppt_images_base_url
    "/convert_ppt/file_entities/#{self.id}"
  end

  def ppt_images
    match_path = File.join(convert_ppt_output_dir,"img*.jpg")
    Dir[match_path].map{|path|PptImage.new(path, ppt_images_base_url)}
  end

  class PptImage
    attr_reader :id, :url, :name
    def initialize(path, base_url)
      @name = File.basename(path)
      @id = @name.match(/img([0-9]*).jpg/)[1]
      @url = File.join(base_url, @name)
    end
  end

end
