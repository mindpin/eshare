# -*- coding: utf-8 -*-
require "spec_helper"

describe TudouVideo do
  before {
    @video1 = TudouVideo.new 'http://www.tudou.com/albumplay/4NP7mtf2VYg/yqM7MXyWjPc.html'
    @video2 = TudouVideo.new 'http://www.tudou.com/programs/view/c7Yv5D7kZew/'
    @video3 = TudouVideo.new 'http://www.tudou.com/listplay/y_WvP2J5LuM.html'
  }

  it {
    p "视频一 iid: #{iid = @video1.iid}"
    iid.should_not be_blank
  }

  it {
    p "视频二 iid: #{iid = @video2.iid}"
    iid.should_not be_blank
  }

  it {
    p "视频三 iid: #{iid = @video3.iid}"
    iid.should_not be_blank
  }
end

describe TudouVideoList do
  let(:list_url) {"http://www.tudou.com/plcover/M9ovmjs6fkw/"}
  let(:lid)      {15632178}
  before {FactoryGirl.create :user, :teacher}

  describe TudouVideoList::Importer do
    describe "#import" do
      let(:importer) {TudouVideoList::Importer.new list_url}
      subject        {importer}

      it {expect {importer.import}.to change {Course.count}.by(1)}
      it {expect {importer.import}.to change {Chapter.count}.by(1)}
      it {expect {importer.import}.to change {CourseWare.count}.by(importer.list.items.count)}
      it 'sets cover for course' do
        importer.import
        Course.first.cover.file.should_not be nil
      end
    end
  end

  describe TudouVideoList::List do
    let(:parser) {TudouVideoList::List.new(list_url)}
    subject      {parser}

    its(:title) {should eq "法语公开课"}
    its(:lid)   {should be lid}

    describe "#items" do
      let(:items) {parser.items}
      subject     {items}

      it {should be_an Array}
      its(:first) {should be_an TudouVideoList::Item}

      describe TudouVideoList::Item do
        subject {items.first}
        
        its(:code) {should eq "bOcUBCwbpbs"}
        its(:desc) {should include "一口好听的法语"}
      end
    end
  end
end
