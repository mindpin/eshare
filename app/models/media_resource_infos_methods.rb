module MediaResourceInfosMethods
  # 这个 module 里都是一些纯粹获取数据的方法

  def video_time_str
    FfmpegMovieInfo.new(self.file_entity.attach.path).raw_duration
  rescue
    "00:00:00"
  end

  def path
    return "/#{self.name}" if self.dir_id == 0
    return "#{self.dir.path}/#{self.name}"
  end

  def attach
    file_entity && file_entity.attach
  end

  def size
    return 0 if self.is_dir? || self.attach.blank?
    return self.attach.size || 0
  end

  def size_str
    return '' if self.is_dir?

    return "#{size}B" if size < 1024
    return "#{(size / 1024.0).round(1)}K" if size < 1048576
    return "#{(size / 1048576.0).round(1)}M" if size < 1073741824
    return "#{(size / 1073741824.0).round(1)}G"
  end

  def mime_type
    self.attach.blank? ? 'application/octet-stream' : self.attach.content_type
  end

  def metadata(options = {:list => true})
    self.is_dir? ? _metadata_dir(options) : _metadata_file
  end

  def is_file?
    !is_dir?
  end

  def is_on_root?
    self.dir_id == 0
  end

  private

    def _metadata_file
      {
        :bytes     => self.size,
        :path      => self.path,
        :is_dir    => false,
        :mime_type => self.mime_type
      }
    end

    def _metadata_dir(options = {})
      contents = options[:list] ? self.media_resources.map { |mr| 
        mr.metadata(:list => false)
      } : [] 

      {
        :bytes    => self.size,
        :path     => self.path,
        :is_dir   => true,
        :contents => contents
      }
    end

end