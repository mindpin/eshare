module FileEntityOuterUrlMethods
  DOWNLOAD_FAILED_URL = 'DOWNLOAD_FAILED_URL'
  DOWNLOADING_URL     = 'DOWNLOADING_URL'
  class DownloadStatus
    READY       = 'READY'
    QUEUE_WAIT  = 'QUEUE_WAIT'
    DOWNLOADING = 'DOWNLOADING'
    SUCCESS     = "SUCCESS"
    FAILURE     = "FAILURE"
    QUEUE_DOWN  = "QUEUE_DOWN"
    REDIS_DOWN  = "REDIS_DOWN"
  end

  def self.included(base)
    base.send(:extend, ClassMethods)
    base.before_save :init_download_status
    base.after_save :download_enqueue_by_status
    base.attr_accessible :outer_url
  end

  def url
    return self.attach.url if download_success?
    return DOWNLOAD_FAILED_URL if download_failed?
    return DOWNLOADING_URL
  end

  def init_download_status
    if self.can_be_downloaded? && self.download_status.blank?
      self.download_status = DownloadStatus::READY
    end
    return true
  end

  def can_be_downloaded?
    !self.outer_url.blank?
  end

  def download_enqueue_by_status
    return download_enqueue if download_ready?
    return true
  end

  def try_download_enqueue_if_need
    return true if download_queue_wait?
    return true if download_downloading?
    return true if download_success?

    download_enqueue
  end

  # 调用队列进行下载
  def download_enqueue
    if Rails.env.test?
      download_downloading!
      return
    end

    if MindpinWorker.sidekiq_running?
      FileEntityDownloadOuterUrl.perform_async(self.id)      
      download_queue_wait!
    else
      download_queue_down!
    end
  rescue Redis::CannotConnectError
    download_redis_down!
  end

  def download_ready?
    self.download_status == DownloadStatus::READY
  end

  def download_queue_wait?
    self.download_status == DownloadStatus::QUEUE_WAIT
  end

  def download_downloading?
    self.download_status == DownloadStatus::DOWNLOADING
  end

  def download_success?
    self.download_status == DownloadStatus::SUCCESS
  end

  def download_failed?
    self.download_status == DownloadStatus::FAILURE
  end

  def download_queue_down?
    self.download_status == DownloadStatus::QUEUE_DOWN
  end
  
  def download_redis_down?
    self.download_status == DownloadStatus::REDIS_DOWN
  end

  def download_downloading!
    self.download_status = DownloadStatus::DOWNLOADING
    self.save
  end

  def download_queue_wait!
    self.download_status = DownloadStatus::QUEUE_WAIT
    self.save
  end

  def download_success!
    self.download_status = DownloadStatus::SUCCESS
    self.save
  end

  def download_failed!
    self.download_status = DownloadStatus::FAILURE
    self.save
  end

  def download_queue_down!
    self.download_status = DownloadStatus::QUEUE_DOWN
    self.save
  end

  def download_redis_down!
    self.download_status = DownloadStatus::REDIS_DOWN
    self.save
  end

  module ClassMethods
    def get_outer_image(outer_url)
      file_entity = self.find_by_outer_url(outer_url)
      if file_entity.present?
        file_entity.try_download_enqueue_if_need
        return file_entity 
      end

      self.create!(
        :attach_file_name => 'ready', 
        :attach_file_size => 0,
        :outer_url => outer_url
      )
    end

    def create_by_text!(content, options)
      ext = options[:ext] || '.txt'
      file = Tempfile.new(['content', ext])
      file.write(content)
      file.rewind
      entity = FileEntity.create!(:attach => file)
      file.unlink
      entity
    end
  end
end