module MediaResourceConvertMethods
  def self.included(base)
    base.after_save :convert_enqueue_if_needed
  end

  def convert_enqueue_if_needed
    return if self.file_entity.blank?
    self.file_entity.convert_enqueue if need_convert?
  end

  def need_convert?
    self.file_entity.is_ppt? ||
    self.file_entity.extname == 'pdf' ||
    self.file_entity.extname == 'doc'
  end
end
