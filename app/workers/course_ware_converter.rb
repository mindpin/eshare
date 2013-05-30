require 'docsplit'

module Docsplit
  class ImageExtractor
    def resize_arg(size)
      return '' if size.nil?
      crop_arg = size[-1] == '#' ? " -gravity Center -crop #{size.gsub('#', '')}+0+0 " : ''
      "-resize #{size.gsub('#', '^')}#{crop_arg}"
    end
  end
end


class CourseWareConverter
  include MindpinWorker
  sidekiq_options :queue => 'course_ware'
  Sidekiq::Queue['course_ware'].limit = 1

  def perform(entity_id)
    entity = FileEntity.find(entity_id)
    entity.convert_converting!
    sizes = ["100%", "800x", "150x150#"]
    Docsplit.extract_images(entity.attach.path,
                            :output => entity.convert_output_dir,
                            :size   => sizes,
                            :format => [:png])
    sizes.zip(%w[origin normal small]).map do |pair|
      pair.map do |item|
        File.join(entity.convert_output_dir, item)
      end
    end.each {|args| FileUtils.mv *args}

    entity.convert_success!
  rescue Exception => ex
    puts ex
    entity.convert_failed!
  end
end
