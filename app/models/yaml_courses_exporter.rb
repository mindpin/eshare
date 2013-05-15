module YamlCoursesExporter
  def self.included(base)
    base.send :extend,  ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def export_to_yaml
      File.open('script/data/video_courses.yaml', 'w+') {|f| f.write(build_yaml)}
    end

  private

    def build_yaml
      Course.all.map(&:course_hash).to_yaml
    end
  end

  module InstanceMethods
    def course_hash
      cover = self.cover.path ? File.basename(self.cover.path) : nil

      {
        :course => {
          :name => self.name, 
          :desc => self.desc, 
          :cover => cover,
          :chapters => build_chapters
        },
        :tags => self.public_tags.map(&:name).join(' ')
      }
    end
  end
end
