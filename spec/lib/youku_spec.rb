require 'spec_helper'


describe YoukuVideoList do
  before {
    @v = YoukuVideoList.new 'http://www.youku.com/show_page/id_z7a3c4ddaaed011e1b52a.html'
  }

  it "id 正确" do
    @v.video_list_id.should == "z7a3c4ddaaed011e1b52a"
  end


  it "point url 正确" do
    @v.show_point_url.should == "http://www.youku.com/show_point_id_z7a3c4ddaaed011e1b52a.html?dt=json&__rt=1&__ro=reload_point"
  end

  it "tab urls 正确" do
    @v.get_tab_urls.should == ["http://www.youku.com/show_point_id_z7a3c4ddaaed011e1b52a.html?dt=json&__rt=1&__ro=reload_point"]
  end

  it "解析结果" do
    p @v.parse
  end
end