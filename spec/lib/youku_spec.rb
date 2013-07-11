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
    let(:url)  {"http://www.youku.com/playlist_show/id_6096855.html"}
    let(:list) {YoukuVideoList::OldPlaylist.new url}
    let(:item) {
      {
        :title => "左轮吉他初级入门教程《人人可以弹吉他》第一课《如何选择学什么吉他》",
        :url   => "http://v.youku.com/v_show/id_XMjY4MjI0ODQ0.html?f=6096855"
      }
    }
    subject    {list}

    its(:id)    {should eq "6096855"}
    its(:count) {should be 105}
    its(:pages) {should be 3}
    its(:items) {should include item}

    its(:course_name) {should include "左轮民谣吉他"}
    its(:course_desc) {should include "焦作滚石琴行"}
  end

  describe YoukuVideoList::CourseMethods do
    let(:user) {FactoryGirl.create :user}
    let(:urls) {
      [
        'http://www.youku.com/show_page/id_z7a3c4ddaaed011e1b52a.html',
        "http://www.youku.com/playlist_show/id_6096855.html"
      ]
    }
    subject {Course.import_youku_video_list(urls[rand 2], user)}

    it "创建了一个默认课程" do
      expect {subject}.to change {Chapter.count}.by(1)
      Course.first.cover.file.should_not be nil
    end
  end
end
