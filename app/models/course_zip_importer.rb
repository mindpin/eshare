require 'zip/zip'

module CourseZipImporter
  OUTDIR = 'tmp/courses'

  def self.included(base)
    base.send :extend, ClassMethods
  end

  class Importer
    attr_reader :zip_path, :out_path, :info, :creator, :course, :chapters

    def initialize(zip_path, creator)
      @zip_path = zip_path
      @out_path = File.join(OUTDIR, "course#{Time.now.utc.strftime("%Y%m%d%H%M%S")}")
      @creator  = creator
      unzip
    end

    def import
      ActiveRecord::Base.transaction do
        import_course
        import_chapters
      end

      clean
    end

  private

    def import_course
      @course = Course.create(:name    => info[:name],
                              :desc    => info[:desc],
                              :cover   => file(info[:cover]),
                              :cid     => info[:cid],
                              :creator => creator)
    end

    def import_chapters
      @chapters = info[:chapters].map do |chapter_info|
        chapter = course.chapters.create(:title   => chapter_info[:title],
                                         :desc    => chapter_info[:desc],
                                         :creator => creator)

        chapter_info[:homeworks].each do |homework_info|
          chapter.homeworks.create(:title   => homework_info[:title],
                                   :chapter => chapter,
                                   :creator => creator)
        end

        chapter_info[:wares].each do |courseware_info|
          ware = chapter.course_wares.new(:title => courseware_info[:name])
          ware = file(File.join('files', courseware_info[:file])))
        end
      end
    end

    def import_homeworks
      @chapters = info[:chapters].map do |chapter_info|
        chapter
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
      @info = parse_course_yaml[:course]
    end

    def file(file_name)
      File.open File.join(out_path, file_name)
    end

    def parse_course_yaml
      HashWithIndifferentAccess.new YAML.load_file(File.join(out_path, 'course.yaml'))
    end

    def clean
      FileUtils.rm_rf out_path
    end
  end

  module ClassMethods
    def import_zip_file(zip_path, creator = User.first)
      Importer.new(zip_path, creator).import
    end
  end
end
