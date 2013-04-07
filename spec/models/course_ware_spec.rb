require 'spec_helper'

describe CourseWare do

  describe 'link_file_entity' do
    before do
      @course_ware = FactoryGirl.create(:course_ware)
      @user = FactoryGirl.create(:user)

      @file_entity = FileEntity.create(
        :attach => File.new(Rails.root.join("spec/data/file_entity.jpg")))

    end

    it{
      @course_ware.file_entity.should == nil
    }

    describe 'link' do
      before do
        @course_ware.link_file_entity(@file_entity)
        @course_ware.reload
      end

      it{
        @course_ware.file_entity.should == @file_entity  
      }

      it{
        @course_ware.kind.should == :image  
      }

      it{
        MediaResource.last.file_entity.should == @file_entity
      }
    end

  end

end