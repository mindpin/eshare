require "spec_helper"

describe "导出 Course 相关数据到 zip" do

  before {
    @course = FactoryGirl.create(:course)
    @dir = 'tmp/export_courses'

    @yaml_file =  @course.convert_into_yaml
    # @yaml_file = YAML.load_file(File.join(@dir, 'course.yaml'))
  }

  it "检测 YAML 格式" do
    @yaml_file["course"].should == {"name"=>"course name", "desc"=>"course content\n", "cover"=>"cover.png", "chapters"=>[{"title"=>"chapter title one", "desc"=>"chapter desc one\n", "wares"=>[{"name"=>"ware one", "file"=>"01.ppt"}, {"name"=>"视频一", "youku"=>"http://v.youku.com/v_show/id_XNTM5MzYxNTE2.html"}, {"name"=>"视频二", "youku"=>"http://v.youku.com/v_show/id_XNTM5MzY3Nzc2.html"}], "homeworks"=>[{"title"=>"homework title one"}, {"title"=>"homework title two"}]}, {"title"=>"chapter title two", "desc"=>"chapter desc two\n", "wares"=>[{"name"=>"ware one", "file"=>"02.ppt"}, {"name"=>"视频一", "youku"=>"http://v.youku.com/v_show/id_XNTM5MzQ2ODI0.html"}], "homeworks"=>[{"title"=>"homework title one"}, {"title"=>"homework title two"}]}]}
  end

  it "封面图片" do
    cover = File.join(@dir, @yaml_file["course"]["cover"])

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
        Dir[@files_dir + '/*.ppt'].should == [@files_dir + '/01.ppt', @files_dir + '/02.ppt']
      end

    end


  end


  describe "检测 zip 包" do
    before {
      @zip = Course.export_zip_file
    }

    it "zip 存在" do
      File.exists?(@zip).should == true
    end

  end

end