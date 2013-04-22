require 'spec_helper'

describe Practice do

  before{
    @user = FactoryGirl.create(:user)
    @chapter = FactoryGirl.create(:chapter)
    @practice = FactoryGirl.create(:practice)
    @file_entity = FactoryGirl.create(:file_entity)
  }

  it "创建习题" do
    expect{
      @chapter.practices.create(:title => '标题', :content => "内容", :creator => @user)
    }.to change{Practice.count}.by(1)
  end


  it "创建习题附件" do
    expect{
      @practice.attaches.create(:file_entity => @file_entity, :name => "附件A")
    }.to change{PracticeAttach.count}.by(1)
  end

  it "创建习题提交物要求" do
    expect{
      @practice.requirements.create(:content => "要求A")
    }.to change{PracticeRequirement.count}.by(1)
  end

  
end