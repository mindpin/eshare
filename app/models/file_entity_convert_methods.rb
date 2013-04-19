module FileEntityConvertMethods
  class ConvertStatus
    READY      = 'READY'
    QUEUE_WAIT = 'QUEUE_WAIT'
    CONVERTING = 'CONVERTING'
    SUCCESS    = "SUCCESS"
    FAILURE    = "FAILURE"
    QUEUE_DOWN = "QUEUE_DOWN"
    REDIS_DOWN = "REDIS_DOWN"
  end

  def self.included(base)
    base.before_save :init_convert_status
    base.after_save :convert_enqueue_by_status
  end

  def init_convert_status
    if can_be_converted? && self.convert_status.blank?
      self.convert_status = ConvertStatus::READY
    end
    return true
  end

  def do_convert(force = false)
    if force && can_be_converted?
      convert_enqueue
      return
    end

    convert_enqueue_by_status
  end

  # 根据 convert_status 的状态判断，如果是ready就开始转码
  def convert_enqueue_by_status
    convert_enqueue if convert_ready?
    return true
  end

  def kind_need_convert?
    self.is_ppt? || self.is_pdf?
  end

  # 判断物理上是否可以进行转码
  def can_be_converted?
    uploaded? && kind_need_convert?
  end

  # ---------------

  def convert_ready?
    self.convert_status == ConvertStatus::READY
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

  # -------------

  # 调用队列进行转码
  def convert_enqueue
    if Rails.env.test?
      convert_converting! # 测试环境下，此方法不去实际访问worker
      return
    end

    if MindpinWorker.sidekiq_running?
      CourseWareConverter.perform_async(self.id)      
      convert_queue_wait!
    else
      convert_queue_down!
    end
  rescue Redis::CannotConnectError
    convert_redis_down!
  end

  def convert_queue_wait!
    self.convert_status = ConvertStatus::QUEUE_WAIT
    self.save
  end

  def convert_converting!
    self.convert_status = ConvertStatus::CONVERTING
    self.save
  end

  def convert_success!
    self.convert_status = ConvertStatus::SUCCESS
    self.save
  end

  def convert_failed!
    self.convert_status = ConvertStatus::FAILURE
    self.save
  end

  def convert_queue_down!
    self.convert_status = ConvertStatus::QUEUE_DOWN
    self.save
  end

  def convert_redis_down!
    self.convert_status = ConvertStatus::REDIS_DOWN
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

  def output_images
    match_path = File.join(convert_output_dir,"*.png")
    Dir[match_path].map{|path| OutputImage.new(path, output_base_url)}.sort_by(&:id)
  end

  class OutputImage
    def initialize(path, base_url)
      @path = path
      @base_url = base_url
    end

    def name
      @name ||= File.basename @path
      @name
    end

    def id
      name.match(/_(\d*).png/)[1].to_i
    end

    def url
      File.join(@base_url, name)
    end

    def dimensions
      @dimensions ||= MiniMagick::Image.open(@path)['dimensions']
      @dimensions
    end

    def width
      dimensions[0]
    end

    def height
      dimensions[1]
    end
  end
end
