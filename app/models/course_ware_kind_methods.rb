module CourseWareKindMethods
  CWKINDS = [
    'youku', 'sina', 'tudou',
    'flv', 
    'ppt', 'pdf',
    
    'javascript'
  ]

  CWKINDS.each do |k|
    define_method "is_#{k}?" do
      k == self.kind.to_s
    end
  end

  def is_pages?
    return is_ppt? || is_pdf?
  end

  # ---

  def is_video?
    return is_web_video? || is_local_video?
  end

  def is_web_video?
    web_video_kinds = ['youku', 'sina', 'tudou']
    web_video_kinds.include? self.kind.to_s
  end

  def is_local_video?
    local_video_kinds = ['flv']
    local_video_kinds.include? self.kind.to_s
  end

  # ---

  def youku_video
    return nil if !self.is_youku?
    return YoukuVideo.new self.url
  end

  def sina_video
    return nil if !self.is_sina?
    return SinaVideo.new self.url
  end

  def tudou_video(user_agent = TudouVideo::DEFAULT_USER_AGENT)
    return nil if !self.is_tudou?
    return TudouVideo.new self.url, user_agent
  end
end