class PDFConverter
  include MindpinWorker

  def perform(entity_id)
    PDFConvert.new(FileEntity.find(entity_id).attach.path).convert
  end
end
