module YamlCoursesImporter
  def self.included(base)
    base.send :extend,  ClassMethods
  end

  module ClassMethods
    def import_from_yaml
      progress = SimpleProgress.new parse_yaml.count
      parse_yaml.each do |course_hash|
        hash = HashWithIndifferentAccess.new course_hash
        CourseZipImporter::Importer.new.init_with_hash(hash, User.first).import
        progress.increment
      end
    end

    def parse_yaml
      @yaml ||= YAML.load_file('./script/data/video_courses.yaml')
    end
  end
end
