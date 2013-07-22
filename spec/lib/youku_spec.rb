# -*- coding: utf-8 -*-
require 'spec_helper'


describe YoukuVideoList do
  describe YoukuVideoList::Playlist do
    before {
      @v = YoukuVideoList::Playlist.new 'http://www.youku.com/show_page/id_z7a3c4ddaaed011e1b52a.html'
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

  describe YoukuVideoList::OldPlaylist do
    let(:url)  {"http://www.youku.com/playlist_show/id_623203.html"}
    let(:list) {YoukuVideoList::OldPlaylist.new url}
    let(:item) {
      {
        :title => "Photoshop从头学起第01集",
        :url   => "http://v.youku.com/v_show/id_XODM3NTQ2MA==.html?f=623203"
      }
    }
    subject    {list}

    its(:id)    {should eq "623203"}
    its(:count) {should be 84}
    its(:pages) {should be 2}
    its(:items) {should include item}

    its(:course_name) {should include "Photoshop视频教程全集"}
    its(:course_desc) {should include "大量Photoshop视频教程"}
  end

  describe YoukuVideoList::CourseMethods do
    let(:user) {FactoryGirl.create :user}
    let(:urls) {
      [
        'http://www.youku.com/show_page/id_z7a3c4ddaaed011e1b52a.html',
        "http://www.youku.com/playlist_show/id_623203.html"
      ]
    }
    subject {Course.import_youku_video_list(urls[rand 2], user)}

    it "创建了一个默认课程" do
      expect {subject}.to change {Chapter.count}.by(1)
      Course.first.cover.file.should_not be nil
    end
  end
end
