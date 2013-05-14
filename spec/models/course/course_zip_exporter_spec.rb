require "spec_helper"


describe "导出 Course 相关数据到 zip" do

  before {
    @dir = 'tmp/export_courses'

    file = File.new(Rails.root.join(*%w[spec fixtures files 01.ppt]))
    @file_entity_1 = FileEntity.create(:attach => file)

    file = File.new(Rails.root.join(*%w[spec fixtures files 02.ppt]))
    @file_entity_2 = FileEntity.create(:attach => file)

    @course = FactoryGirl.create(
      :course, 
      :name => "course name", 
      :desc => "course desc",
      :cover => File.new(Rails.root.join(*%w[spec fixtures files cover.png]))
    )
    @chapter_1 = FactoryGirl.create(
      :chapter, 
      :course => @course,
      :title => "chapter title one",
      :desc => "chapter desc one"
    )

    @ware_1_1 = FactoryGirl.create(
      :course_ware, 
      :chapter => @chapter_1,
      :title => "ware one",
      :kind => 'ppt',
      :file_entity => @file_entity_1
    )

    @ware_1_2 = FactoryGirl.create(
      :course_ware, 
      :chapter => @chapter_1,
      :title => "video one",
      :kind => 'youku',
      :url => "http://v.youku.com/v_show/id_XNTM5MzYxNTE2.html"
    )

    @homework_1_1 = FactoryGirl.create(
      :homework, 
      :chapter => @chapter_1,
      :title => "homework title one"
    )

    @homework_1_2 = FactoryGirl.create(
      :homework, 
      :chapter => @chapter_1,
      :title => "homework title two"
    )


    @chapter_2 = FactoryGirl.create(
      :chapter, 
      :course => @course,
      :title => "chapter title two",
      :desc => "chapter desc two"
    )

    @ware_2_1 = FactoryGirl.create(
      :course_ware, 
      :chapter => @chapter_2,
      :title => "ware one",
      :kind => 'ppt',
      :file_entity => @file_entity_2
    )

    @ware_2_2 = FactoryGirl.create(
      :course_ware, 
      :chapter => @chapter_2,
      :title => "video one",
      :kind => 'youku',
      :url => "http://v.youku.com/v_show/id_XNTM5MzQ2ODI0.html"
    )

    @homework_2_1 = FactoryGirl.create(
      :homework, 
      :chapter => @chapter_2,
      :title => "homework title one"
    )

  }


  describe "检测 zip 目录" do

    before {

      @course.build_zip_dir
      @yaml_file = YAML.load_file(File.join(@dir, 'course.yaml'))
      @yaml_file = @yaml_file[:course]

    }

    after {FileUtils.rm_rf 'tmp/export_courses'}



    it "检测 YAML 格式" do

      @yaml_file.should == {
        :name => @course.name, 
        :desc => @course.desc, 
        :cover => File.basename(@course.cover.path),
        :chapters => [
          {
            :title => @chapter_1.title,
            :desc => @chapter_1.desc,
            :wares => [
              {
                :name => @ware_1_1.title,
                :kind => @ware_1_1.kind.to_s,
                :file => @ware_1_1.file_entity.saved_file_name
              },
              {
                :name => @ware_1_2.title,
                :kind => "youku",
                :url => @ware_1_2.url,
              }
            ],
            :homeworks => [
              {
                :title => @homework_1_1.title,
              },
              {
                :title => @homework_1_2.title
              }
            ]
          },
          {
            :title => @chapter_2.title,
            :desc => @chapter_2.desc,
            :wares => [
              {
                :name => @ware_2_1.title,
                :kind => @ware_1_1.kind.to_s,
                :file => @ware_2_1.file_entity.saved_file_name
              },
              {
                :name => @ware_2_2.title,
                :kind => "youku",
                :url => @ware_2_2.url,
              }
            ],
            :homeworks => [
              {
                :title => @homework_2_1.title,
              }
            ]
          }
        ]
      }


    end

    it "封面图片" do
      cover = File.join(@dir, File.basename(@yaml_file[:cover]))

      File.exist?(cover).should == true
    end

    describe "files 目录" do
      before {
        @files_dir = File.join(@dir, "files")
      }  

      it "files 路径存在" do
        File.exists?(@files_dir).should == true
      end

      it "确定是个文件目录" do
        File.directory?(@files_dir).should == true
      end
      

      describe "files 目录有 PPT" do

        it "ppt 检测" do
          file1 = File.join(@dir, "files", File.basename(@file_entity_1.attach.path))
          file2 = File.join(@dir, "files", File.basename(@file_entity_2.attach.path))

          Dir[@files_dir + '/*.ppt'].should =~ [file1, file2]
        end

      end


    end

  end

  


  describe "检测 zip 包" do
    before {
      @zip = @course.make_zip
    }

    after {FileUtils.rm @zip}

    it "zip 存在" do
      File.exists?(@zip).should == true
    end

  end


end