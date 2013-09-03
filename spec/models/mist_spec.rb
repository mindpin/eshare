require 'spec_helper'

describe Mist do
  context 'create' do

    it " 创建一个Mist " do
      expect{
        Mist.create!(
                     :desc => 'desc1',
                     :kind => 'java',
                     :content => 'content1'
                    )
      }.to change{Mist.count}.by(1)
    end

    it " kind 为空时 " do
      expect{
        Mist.create(
                     :desc => 'desc1',
                     :kind => nil,
                     :content => 'content2'
                    )
      }.to change{Mist.count}.by(0)
    end

    it " kind 为非指定时 " do
      expect{
        Mist.create(
                     :desc => 'desc1',
                     :kind => 'nil',
                     :content => 'content3'
                    )
      }.to change{Mist.count}.by(0)
    end

    it " content  javascript" do
        @mist = Mist.create!(
                     :desc => 'desc1',
                     :kind => 'javascript',
                     :content => 'content1afasdfasfasdfsf'
                    )

        @mist.file_entity.attach.path.last(2).should === 'js'

    end

    it " content  ruby" do
        @mist = Mist.create!(
                     :desc => 'desc1',
                     :kind => 'ruby',
                     :content => 'content1afasdfasfasdfsf'
                    )

        @mist.file_entity.attach.path.last(2).should === 'rb'

    end

    it " content  " do
        content = 'content1afasdfasfasdfsf'
        @mist = Mist.create!(
                     :desc => 'desc1',
                     :kind => 'ruby',
                     :content => content
                    )
        old_content = File.open(@mist.file_entity.attach.path).read
        old_content.should === content
    end

    it " content save nil" do
      mist = Mist.new
      mist.content.should === ""
    end
    it "content no save" do
      mist = Mist.new
      mist.content = "123"
      mist.content.should === "123"
    end

    it "content save" do
      mist = Mist.new
      mist.desc = "desc1"
      mist.kind = "text"
      mist.content = "123"
      mist.save!

      find_mist = Mist.find(mist.id)
      old_content = File.open(find_mist.file_entity.attach.path).read
      old_content.should === "123"
    end
  end
end