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

  def convert_ppt_path
    File.join(R::CONVERT_BASE_PATH, convert_ppt_url)
  end

  def convert_ppt_url
    "/convert_ppt/file_entities/#{self.id}.swf"
  end
end
