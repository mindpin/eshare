require 'spec_helper'

describe Homework do
  describe '创建没有要求的作业' do
    before{
      @user = FactoryGirl.create(:user)
      @chapter = FactoryGirl.create(:chapter)
    }

    it{
      expect{
        @chapter.homeworks.create(
          :title => '标题', :content => "内容", 
          :deadline => Time.now + 10.day,
          :creator => @user
          )
      }.to change{Homework.count}.by(1)
    }
  end

  describe '创建有要求的作业' do
    before(:each) do
      user = FactoryGirl.create(:user)
      chapter = FactoryGirl.create(:chapter)

      homework_requirements_attributes = [
        {:content => "要求一"},
        {:content => "要求二"}
      ]

      homework = chapter.homeworks.create(
        :title => '标题', :content => "内容", 
        :deadline => Time.now + 10.day, :creator => user,
        :homework_requirements_attributes => homework_requirements_attributes
        )

      @homework = Homework.find(homework.id)
    end

    it{
      @homework.homework_requirements.count.should == 2
    }

    it{
      @homework.homework_requirements.first.homework.should == @homework
      @homework.homework_requirements.first.content.should == '要求一'
    }

    it{
      @homework.homework_requirements.last.homework.should == @homework
      @homework.homework_requirements.last.content.should == '要求二'
    }

    describe '提交作业 upload' do
      before(:each){
        @requirement_1 = @homework.homework_requirements.first
        @requirement_2 = @homework.homework_requirements.last
        @user_1 = FactoryGirl.create(:user)
        @file_entity = FactoryGirl.create(:file_entity)
      }

      it{
        @requirement_1.get_upload_by(@user_1).blank?.should == true
        @requirement_1.is_uploaded_by?(@user_1).should == false
      }

      it{
        @requirement_1.homework_uploads.create(:file_entity_id => @file_entity.id, :creator => @user_1, :name => "作业提交物")

        @requirement_1.is_uploaded_by?(@user_1).should == true
        upload = @requirement_1.get_upload_by(@user_1)
        upload.file_entity_id.should == @file_entity.id
        upload.name.should == "作业提交物"
      }

      describe '判断一个用户是否完全提交了一个作业' do
        it{
          @homework.is_submit_by_user?(@user_1).should == false
        }

        it{
          @requirement_1.homework_uploads.create(:file_entity_id => @file_entity.id, :creator => @user_1, :name => "作业提交物1")
          @homework.is_submit_by_user?(@user_1).should == false
        }

        it{
          @requirement_1.homework_uploads.create(:file_entity_id => @file_entity.id, :creator => @user_1, :name => "作业提交物1")
          @requirement_2.homework_uploads.create(:file_entity_id => @file_entity.id, :creator => @user_1, :name => "作业提交物2")
          @homework.is_submit_by_user?(@user_1).should == true
        }
      end
    end
  end

  describe '创建有附件的作业' do
    before(:each) do
      user = FactoryGirl.create(:user)
      chapter = FactoryGirl.create(:chapter)
      @file_entity_1 = FactoryGirl.create(:file_entity)
      @file_entity_2 = FactoryGirl.create(:file_entity)
      
      homework_attaches_attributes = [
        {:file_entity_id => @file_entity_1.id, :name => '附件一'},
        {:file_entity_id => @file_entity_2.id, :name => '附件二'}
      ]

      homework = chapter.homeworks.create(
        :title => '标题', :content => "内容", 
        :deadline => Time.now + 10.day, :creator => user,
        :homework_attaches_attributes => homework_attaches_attributes
        )

      @homework = Homework.find(homework.id)
    end

    it{
      @homework.homework_attaches.count.should == 2
    }

    it{
      @homework.homework_attaches.first.file_entity.should == @file_entity_1
      @homework.homework_attaches.first.name.should == '附件一'
      @homework.homework_attaches.first.homework.should == @homework
    }


    it{
      @homework.homework_attaches.last.file_entity.should == @file_entity_2
      @homework.homework_attaches.last.name.should == '附件二'
      @homework.homework_attaches.last.homework.should == @homework
    }
  end
  
  describe '过期作业和未过期作业' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      chapter = FactoryGirl.create(:chapter)

      @homework_1 = chapter.homeworks.create(
        :title => '标题1', :content => "内容1", :creator => @user,
        :deadline => Time.now + 10.day)

      @homework_2 = chapter.homeworks.create(
        :title => '标题2', :content => "内容2", :creator => @user,
        :deadline => Time.now + 11.day)

      @homework_3 = chapter.homeworks.create(
        :title => '标题3', :content => "内容3", :creator => @user,
        :deadline => Time.now - 10.day)

      @homework_4 = chapter.homeworks.create(
        :title => '标题4', :content => "内容4", :creator => @user,
        :deadline => Time.now - 11.day)
    end

    it{
      @user.created_homeworks.count.should == 4
    }

    it{
      @user.created_homeworks.expired.count.should == 2
      @user.created_homeworks.expired.include?(@homework_3).should == true
      @user.created_homeworks.expired.include?(@homework_4).should == true
    }


    it{
      @user.created_homeworks.unexpired.count.should == 2
      @user.created_homeworks.unexpired.include?(@homework_1).should == true
      @user.created_homeworks.unexpired.include?(@homework_2).should == true
    }
  end

  describe 'Homework.by_course(course)' do
    before{
      @course_1 = FactoryGirl.create(:course)

      @chapter_1_1 = FactoryGirl.create(:chapter, :course => @course_1)
      @homework_1_1_1 = FactoryGirl.create(:homework, :chapter => @chapter_1_1)
      @homework_1_1_2 = FactoryGirl.create(:homework, :chapter => @chapter_1_1)

      @chapter_1_2 = FactoryGirl.create(:chapter, :course => @course_1)
      @homework_1_2_1 = FactoryGirl.create(:homework, :chapter => @chapter_1_2)
      @homework_1_2_2 = FactoryGirl.create(:homework, :chapter => @chapter_1_2)      

      @course_other = FactoryGirl.create(:course)
      @chapter_other = FactoryGirl.create(:chapter, :course => @course_other)
      @homework_other = FactoryGirl.create(:homework, :chapter => @chapter_other)
    }

    it{
      Homework.by_course(@course_1).count.should == 4
    }

    it{
      Homework.by_course(@course_1).should =~ [
        @homework_1_1_1,
        @homework_1_1_2,
        @homework_1_2_1,
        @homework_1_2_2
      ]
    }

    it{
      Homework.by_course(@course_other).should == [@homework_other]
    }
  end
end
