class CourseWareConverter
  include MindpinWorker

  def perform(entity_id)
    entity = FileEntity.find(entity_id)
    Docsplit.extract_images(entity.attach.path,
                            :output => entity.convert_output_dir,
                            :size   => '800x',
                            :format => [:png])
    entity.convert_success!
  rescue
    entity.convert_failed!
  end
end
