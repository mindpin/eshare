module YamlCoursesImporter
  def self.included(base)
    base.send :extend,  ClassMethods
  end

  module ClassMethods
    def import_from_yaml
      progress = SimpleProgress.new parse_yaml.count
      parse_yaml.each do |course_hash|
        hash = HashWithIndifferentAccess.new course_hash
        user = User.first
        CourseZipImporter::Importer.new.init_with_hash(hash, user).import
        progress.increment
      end
    end

    def import_from_yaml_for_web
      progress = SimpleProgress.new parse_yaml.count
      count = parse_yaml.count
      parse_yaml.each_with_index do |course_hash, index|
        user_id = (index+1) % 19 + 2
        hash = HashWithIndifferentAccess.new course_hash
        user = User.find(user_id)
        CourseZipImporter::Importer.new.init_with_hash(hash, user).import
        progress.increment
      end
    end

    def parse_yaml
      @yaml ||= YAML.load_file('./script/data/video_courses.yaml')
    end
  end
end
