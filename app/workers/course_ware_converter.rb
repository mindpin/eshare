class CourseWareConverter
  include MindpinWorker
  sidekiq_options :queue => 'course_ware'
  Sidekiq::Queue['course_ware'].limit = 1

  def perform(entity_id)
    entity = FileEntity.find(entity_id)
    entity.convert_converting!
    Docsplit.extract_images(entity.attach.path,
                            :output => entity.convert_output_dir,
                            :format => [:png])
    entity.convert_success!
  rescue Exception => ex
    puts ex
    entity.convert_failed!
  end
end
