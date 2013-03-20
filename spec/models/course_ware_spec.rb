require 'spec_helper'

describe CourseWare do

  describe '关联一个 media_resource' do
    after(:all) do
      User.all.each{|user|user.destroy}
    end
    before(:all) do
      @course_ware = FactoryGirl.create(:course_ware)
      @user = FactoryGirl.create(:user)

      file_entity = FileEntity.create(
        :attach => File.new(Rails.root.join("spec/data/file_entity.jpg")))

      @media_resource = MediaResource.create(
        :name => '喜洋洋.jpg', 
        :is_dir => false, 
        :creator => @user,
        :file_entity => file_entity
        )
    end

    it{
      @course_ware.link_media_resource(@media_resource)
      @course_ware.reload
      @course_ware.media_resource.should == @media_resource
      @course_ware.kind.should == :image
    }
    
  end

end