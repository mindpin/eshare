module YamlCoursesImporter
  def self.included(base)
    base.send :extend,  ClassMethods
  end

  module ClassMethods
    def import_from_yaml
      parse_yaml.each do |course_hash|
        hash = HashWithIndifferentAccess.new course_hash
        CourseZipImporter::Importer.new.init_with_hash(hash, User.first).import
      end
    end

    def parse_yaml
      @yaml ||= YAML.load_file('./script/data/video_courses.yaml')
    end
  end
end
