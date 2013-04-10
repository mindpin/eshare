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

      it {
        @course_ware.file_entity.should == @file_entity  
      }

      it {
        @course_ware.kind.should == 'image'
      }

      it {
        MediaResource.last.file_entity.should == @file_entity
      }

      it {
        @course_ware.media_resource.should == MediaResource.last
      }

      it {
        MediaResource.last.destroy
        @course_ware.reload
        @course_ware.media_resource.should be_blank
      }
    end

  end


  context '课程进度: 记录课件的已读状态' do
    before do
      @course_ware = FactoryGirl.create(:course_ware)
      @user = FactoryGirl.create(:user)
    end
    
    describe '#sign_reading' do
      it{expect {@course_ware.sign_reading(@user)}.to change {CourseWareReading.count}.by(1)}
    end

    describe '#has_read?' do
      context '用户未读' do
        it    { @course_ware.has_read?(@user).should == false}
      end
      context '用户已经读' do
        before{ @course_ware.sign_reading(@user) }
        it    { @course_ware.has_read?(@user).should == true}
      end
    end

    describe '#has_read?' do
      let(:user1) { FactoryGirl.create(:user) }
      let(:user2) { FactoryGirl.create(:user) }
      let(:user3) { FactoryGirl.create(:user) }
      let(:user4) { FactoryGirl.create(:user) }
      let(:user5) { FactoryGirl.create(:user) }
      before do 
        @course_ware.sign_reading(user1)
        @course_ware.sign_reading(user2)
        @course_ware.sign_reading(user3)
        @course_ware.sign_reading(user4)
        @course_ware.sign_reading(user5)
      end
      it    { @course_ware.readed_count.should == 5 }
    end
  end
end