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
      @course_ware   = FactoryGirl.create(:course_ware, :total_count => nil)
      @course_ware1  = FactoryGirl.create(:course_ware, :total_count => 3)
      @user          = FactoryGirl.create(:user)
    end
    
    describe '#sign_read_count' do
      context '验证 read_count < total_count' do
        it{expect {@course_ware1.sign_reading_count(@user,1)}.to change {@course_ware1.readed_count}.by(0)}
      end
      context '验证 read_count = total_count' do
        it{expect {@course_ware1.sign_reading_count(@user,3)}.to change {@course_ware1.readed_count}.by(1)}
      end
      context '标记为未读' do
        before    { @course_ware1.sign_reading_count(@user,3) }
        it{expect {@course_ware1.sign_no_reading(@user)}.to change {@course_ware1.readed_count}.by(-1)}
      end

      context '验证 read_count > total_count' do
        it{expect {@course_ware1.sign_reading_count(@user,4)}.to change {@course_ware1.readed_count}.by(0)}
      end

      context '验证  read_count == fotal_count && !read' do
        before    do 
          @reading = CourseWareReading.new(:course_ware => @course_ware1, :user => @user, :read => false, :read_count => 3) 
        end
        it{ @reading.valid? .should == false }
      end
    end

    describe '#sign_reading #sign_no_reading' do
      context '验证 read_count' do
        before    { @course_ware.sign_reading(@user) }
        it  { @course_ware.get_readed_by_user(@user).read_count == nil}
      end

      context '标记为已读' do
        it{expect {@course_ware.sign_reading(@user)}.to change {@course_ware.readed_count}.by(1)}
      end

      context '标记为未读' do
        before    { @course_ware.sign_reading(@user) }
        it{expect { @course_ware.sign_no_reading(@user)}.to change {@course_ware.readed_count}.by(-1)}
      end
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

    describe '#readed_count' do
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

  describe '网络视频类型' do
    before {
      @course_ware = FactoryGirl.create :course_ware, :kind => :youku
    }

    it {
      CourseWare.last.is_web_video?.should == true
    }
  end

  describe 'by_course' do
    before{
      @course_1 = FactoryGirl.create(:course)
      @chapter_1_1 = FactoryGirl.create(:chapter, :course => @course_1)
      @course_ware_1_1_1 = FactoryGirl.create(:course_ware, :chapter => @chapter_1_1)
      @course_ware_1_1_2 = FactoryGirl.create(:course_ware, :chapter => @chapter_1_1)
      @chapter_1_2 = FactoryGirl.create(:chapter, :course => @course_1)
      @course_ware_1_2_1 = FactoryGirl.create(:course_ware, :chapter => @chapter_1_2)

      @course_2 = FactoryGirl.create(:course)
      @chapter_2_1 = FactoryGirl.create(:chapter, :course => @course_2)
      @course_ware_2_1 = FactoryGirl.create(:course_ware, :chapter => @chapter_2_1)
    }

    it{
      CourseWare.by_course(@course_1).should =~ [
        @course_ware_1_1_1,
        @course_ware_1_1_2,
        @course_ware_1_2_1
      ]
    }

    it{
      CourseWare.by_course(@course_2).should =~ [@course_ware_2_1]
    }
  end

  describe 'CourseWare.read_with_user(user)' do
    before{
      @course_ware_1 = FactoryGirl.create(:course_ware)
      @course_ware_2 = FactoryGirl.create(:course_ware)
      @course_ware_3 = FactoryGirl.create(:course_ware)
      @course_ware_4 = FactoryGirl.create(:course_ware)

      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)
    }

    it{
      CourseWare.read_with_user(@user_1).should == []
    }

    it{
      CourseWare.read_with_user(@user_2).should == []
    }

    describe '分别进行阅读' do
      before{
        @course_ware_1.sign_reading(@user_1)
        @course_ware_4.sign_reading(@user_1)

        @course_ware_1.sign_reading(@user_2)
        @course_ware_3.sign_reading(@user_2)
      }

      it{
        CourseWare.read_with_user(@user_1).should =~ [
          @course_ware_1,
          @course_ware_4
        ]
      }

      it{
        CourseWare.read_with_user(@user_2).should =~ [
          @course_ware_1,
          @course_ware_3
        ]
      }
    end


  end


end
