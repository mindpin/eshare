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

    if MindpinWorker.sidekiq_running?
      self.convert_status = ConvertStatus::CONVERTING
      self.save
      converter_dispatch.perform_async(self.id)      
    else
      self.convert_status = ConvertStatus::QUEUE_DOWN
      self.save
    end
  rescue Redis::CannotConnectError
    convert_failed!
  end

  def converter_dispatch
    case self.extname
    when 'doc', 'ppt'
      PPTDocConverter
    when 'pdf'
      PDFConverter
    end
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
    File.join(R::CONVERT_BASE_PATH, "/convert_#{content_kind}/file_entities/#{self.id}")
  end

  def convert_output_index_html
    File.join(convert_output_dir,'index.html')
  end

  def convert_output_index_png
    File.join(convert_output_dir,'index.png')
  end

  def output_base_url
    "/convert_#{content_kind}/file_entities/#{self.id}"
  end

  def doc_html
    File.join(convert_output_dir,"index.html")
  end

  def pdf_images
    match_path = File.join(convert_output_dir,"index_*.png")
    Dir[match_path].map{|path|PDFImage.new(path, output_base_url)}.sort_by(&:id)
  end

  def ppt_images
    match_path = File.join(convert_output_dir,"img*.jpg")
    Dir[match_path].map{|path|PptImage.new(path, output_base_url)}
  end

  class PDFImage
    attr_reader :id, :url, :name
    def initialize(path, base_url)
      @name = File.basename(path)
      @id = @name.match(/index_0*(\d*).png/)[1].to_i
      @url = File.join(base_url, @name)
    end
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
