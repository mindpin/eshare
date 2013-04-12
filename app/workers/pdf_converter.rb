class PDFConverter
  include MindpinWorker

  def perform(entity_id)
    entity = FileEntity.find(entity_id)
    PDFConvert.new(entity.attach.path, entity.convert_output_index_png).convert
    entity.convert_success!
  rescue
    entity.convert_failed!
  end
end
