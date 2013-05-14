require 'zip/zip'

module CourseZipImporter
  OUTDIR = 'tmp/courses'

  def self.included(base)
    base.send :extend, ClassMethods
  end

  class Importer
    attr_reader :zip_path, :load_path, :info, :creator, :course, :files

    def init_with_hash(hash, creator)
      @info      = hash[:course]
      @tags      = hash[:tags]
      @creator   = creator
      self
    end

    def init_with_zip(zip_path, creator)
      @zip_path  = zip_path
      @load_path = File.join(OUTDIR, "course#{Time.now.utc.strftime("%Y%m%d%H%M%S")}")
      @creator   = creator
      @files     = []
      unzip
      @info      = parse_yaml[:course]
      @tags      = parse_yaml[:tags]
      self
    end

    def import
      import_course
      import_chapters
      clean
    end

  private

    def import_course
      cover = info[:cover] ? file(info[:cover]) : nil
      cid = Time.now.utc.strftime("%Y%m%d%H%M%S%L") + randstr

      @course = Course.create(:name    => info[:name],
                              :desc    => info[:desc],
                              :cover   => cover,
                              :cid     => cid,
                              :creator => creator)

      @course.replace_public_tags(@tags, creator) if !@tags.blank?
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

        chapter_info[:wares].each do |courseware|
          ware = chapter.course_wares.new(
            :title => courseware[:name],
            :creator => creator
          )

          case courseware[:kind]
          when 'youku'
            ware.url = courseware[:url]
          else
            file = file(File.join('files', courseware[:file]))
            ware.file_entity = FileEntity.create(:attach => file)
          end
          ware.kind = courseware[:kind]

          ware.save
        end
      end
    end

    def unzip
      Zip::ZipFile::open(zip_path) do |zip|
        zip.each do |entry|
          dest_path = File.join(load_path, entry.name)
          FileUtils.mkdir_p(File.dirname(dest_path))
          zip.extract(entry, dest_path)
        end
      end
    end

    def file(file_name)
      file = File.open(File.join(load_path, file_name))
      files << file
      file
    end

    def parse_yaml
      HashWithIndifferentAccess.new YAML.load_file(File.join(load_path, 'course.yaml'))
    end

    def clean
      files.each(&:close) if files
      FileUtils.rm_rf load_path if load_path
    end
  end

  module ClassMethods
    def import_zip_file(zip_path, creator = User.first)
      Importer.new.init_with_zip(zip_path, creator).import
    end
  end
end
