module MediaResourceConvertMethods
  def self.included(base)
    base.after_save :convert_enqueue_if_needed
  end

  def convert_enqueue_if_needed
    return if self.file_entity.blank?
    self.file_entity.convert_enqueue if self.file_entity.is_ppt?
  end
end