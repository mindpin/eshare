require 'zip/zip'

module CourseZipExporter
  @@target_path = 'tmp/export_courses'
  @@target_zip = "tmp/course#{Time.now.utc.strftime("%Y%m%d%H%M%S")}.zip"

  def generate_yaml_file
    FileUtils.mkdir_p(Rails.root.join(@@target_path))
    target_file = File.join(@@target_path, "course.yaml")

    File.open(target_file, 'w+') {|f| f.write(build_yaml) }
  end


  def build_zip_dir
    generate_yaml_file
    copy_cover
  end

  def make_zip
    build_zip_dir
    do_zip
  end
  

  private

    def build_yaml

      cover_name = File.basename(self.cover.path)

      course_hash = {
        :name => self.name, 
        :desc => self.desc, 
        :cover => cover_name,
        :chapters => build_chapters
      }

      {:course => course_hash}.to_yaml
      
    end

    def build_chapters
      chapters_arr = []

      chapters.each do |chapter|
        wares = []

        chapter.course_wares.each do |ware|
          wares << build_wares(ware)
          copy_ware_files(ware)
        end

        homeworks = build_homeworks(chapter)

        chapters_arr << {
          :title => chapter.title,
          :desc => chapter.desc,
          :wares => wares,
          :homeworks => homeworks
        }
      end

      chapters_arr
    end

    def build_wares(ware)
      if ware.is_web_video?
        return {:name => ware.title, :kind => "youku", :url => ware.url}
      end
      
      return {:name => ware.title} if ware.file_entity.nil?

      {:name => ware.title, :kind => ware.kind, :file => ware.file_entity.saved_file_name}
       
    end



    def build_homeworks(chapter)
      homeworks = []

      chapter.homeworks.each do |homework|
        homeworks << {:title => homework.title}
      end
      homeworks
    end

    def copy_cover
      filename = File.basename(self.cover.path)
      FileUtils.copy_file(self.cover.path, Rails.root.join(@@target_path, filename))
    end


    def copy_ware_files(ware)
      files_dir = Rails.root.join(@@target_path, "files")
      if !File.directory?(files_dir)
        FileUtils.mkdir(files_dir)
      end

      return if ware.file_entity.nil?

      filename = File.basename(ware.file_entity.attach.path)
      FileUtils.copy_file(ware.file_entity.attach.path, File.join(files_dir, filename))
    end

    def do_zip
      input_filenames = ["course.yaml", File.basename(self.cover.path)]

      zipfile_name = Rails.root.join(@@target_zip)

      Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
        input_filenames.each do |filename|
          zipfile.add(filename, @@target_path + '/' + filename)
        end

        files = Dir[@@target_path + "/files" + '/*.*']
        files.each do |file|
          zipfile.add("files/" + File.basename(file), file)
        end
      end

      zipfile_name
    end


end