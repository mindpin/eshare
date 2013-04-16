require 'zip/zip'

module CourseZipImporter
  OUTDIR = 'tmp/courses'

  def self.included(base)
    base.send :extend, ClassMethods
  end

  class Importer
    attr_reader :zip_path, :out_path, :info, :creator, :course, :files

    def initialize(zip_path, creator)
      @zip_path = zip_path
      @out_path = File.join(OUTDIR, "course#{Time.now.utc.strftime("%Y%m%d%H%M%S")}")
      @creator  = creator
      @files    = []
      unzip
      @info = parse_course_yaml[:course]
    end

    def import
      import_course
      import_chapters
      clean
    end

  private

    def import_course
      @course = Course.create(:name    => info[:name],
                              :desc    => info[:desc],
                              :cover   => file(info[:cover]),
                              :cid     => rand(999),
                              :creator => creator)
    end

    def import_chapters
      info[:chapters].each do |chapter_info|
        chapter = course.chapters.create(:title   => chapter_info[:title],
                                         :desc    => chapter_info[:desc],
                                         :creator => creator)

        chapter_info[:homeworks].each do |homework_info|
          chapter.homeworks.create(:title   => homework_info[:title],
                                   :chapter => chapter,
                                   :creator => creator)
        end

        chapter_info[:wares].each do |courseware_info|
          ware = chapter.course_wares.new(:title   => courseware_info[:name],
                                          :creator => creator)
          if courseware_info[:file]
            file = file(File.join('files', courseware_info[:file]))
            ware.file_entity = FileEntity.create(:attach => file)
          elsif courseware_info[:youku]
            ware.url = courseware_info[:youku]
            ware.kind = 'youku'
          end

          ware.save
        end
      end
    end

    def unzip
      Zip::ZipFile::open(zip_path) do |zip|
        zip.each do |entry|
          dest_path = File.join(out_path, entry.name)
          FileUtils.mkdir_p(File.dirname(dest_path))
          zip.extract(entry, dest_path)
        end
      end
    end

    def file(file_name)
      file = File.open(File.join(out_path, file_name))
      files << file
      file
    end

    def parse_course_yaml
      HashWithIndifferentAccess.new YAML.load_file(File.join(out_path, 'course.yaml'))
    end

    def clean
      files.each(&:close)
      FileUtils.rm_rf out_path
    end
  end

  module ClassMethods
    def import_zip_file(zip_path, creator = User.first)
      Importer.new(zip_path, creator).import
    end
  end
end
