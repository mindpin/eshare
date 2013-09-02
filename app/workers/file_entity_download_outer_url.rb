require 'open-uri'

class FileEntityDownloadOuterUrl
  include MindpinWorker
  sidekiq_options :queue => 'course_ware'

  def perform(entity_id)
    entity = FileEntity.find(entity_id)
    entity.download_downloading!
    file = Tempfile.new(['image', '.png'],:binmode => true)
    file.write(open(entity.outer_url).read)
    file.rewind
    entity.attach = file
    entity.download_success!
    file.unlink
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace*"\n"
    entity.download_failed!
  end
end
