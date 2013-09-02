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

  end
end