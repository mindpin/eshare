require 'spec_helper'

describe CourseFeedTimelime do
  before{
    @user_1 = FactoryGirl.create(:user)
    @user_2 = FactoryGirl.create(:user)

    @course_1 = FactoryGirl.create(:course)
    chapter_1 = FactoryGirl.create(:chapter, :course => @course_1)
    @course_ware_1 = FactoryGirl.create(:course_ware, :chapter => chapter_1)
    @practice_1 = FactoryGirl.create(:practice, :chapter => chapter_1)
    @course_ware_2 = FactoryGirl.create(:course_ware, :chapter => chapter_1)
    @practice_2 = FactoryGirl.create(:practice, :chapter => chapter_1)

    @course_2 = FactoryGirl.create(:course)
    chapter_2 = FactoryGirl.create(:chapter, :course => @course_2)
    @course_ware_3 = FactoryGirl.create(:course_ware, :chapter => chapter_2)
    @practice_3 = FactoryGirl.create(:practice, :chapter => chapter_2)
    @course_ware_4 = FactoryGirl.create(:course_ware, :chapter => chapter_2)
    @practice_4 = FactoryGirl.create(:practice, :chapter => chapter_2)
  }

  it{
    @course_1.course_feed_timeline_db.should == []
    @course_2.course_feed_timeline_db.should == []
    @user_1.course_feed_timeline_db.should == []
    @user_2.course_feed_timeline_db.should == []
  }

  it{
    @course_1.course_feed_timeline.should == []
    @course_2.course_feed_timeline.should == []
    @user_1.course_feed_timeline.should == []
    @user_2.course_feed_timeline.should == []
  }

  context 'user_1 在 course_1 操作' do
    before{
      # 学习课件
      @course_ware_1.set_read_by!(@user_1)
      @course_ware_reading_11 = @course_ware_1.course_ware_readings.by_user(@user_1).first
      @course_ware_2.set_read_by!(@user_1)
      @course_ware_reading_21 = @course_ware_2.course_ware_readings.by_user(@user_1).first
      # 提问问题
      @question_1 = FactoryGirl.create(:question, :model => @course_ware_1, :creator => @user_1)
      # 做练习
      @practice_1.submit_by_user(@user_1)
      @practice_record_11 = @practice_1.records.where(:user_id => @user_1).first
      @practice_2.submit_by_user(@user_1)
      @practice_record_21 = @practice_2.records.where(:user_id => @user_1).first
    }

    it{
      @course_2.course_feed_timeline_db.should == []
      @user_2.course_feed_timeline_db.should == []
    }

    it{
      @course_2.course_feed_timeline.should == []
      @user_2.course_feed_timeline.should == []
    }

    it{
      @course_1.course_feed_timeline_db.map(&:to).should == [
        @practice_record_21, @practice_record_11, 
        @question_1, @course_ware_reading_21, @course_ware_reading_11
      ]
    }

    it{
      @course_1.course_feed_timeline.map(&:to).should == [
        @practice_record_21, @practice_record_11, 
        @question_1, @course_ware_reading_21, @course_ware_reading_11
      ]
    }

    it{
      @user_1.course_feed_timeline_db.map(&:to).should == [
        @practice_record_21, @practice_record_11, 
        @question_1, @course_ware_reading_21, @course_ware_reading_11
      ]
    }

    it{
      @user_1.course_feed_timeline.map(&:to).should == [
        @practice_record_21, @practice_record_11, 
        @question_1, @course_ware_reading_21, @course_ware_reading_11
      ]
    }

    context '综合测试' do
      before{
        # user_1 在 course_2 操作
        # 学习课件
        @course_ware_3.set_read_by!(@user_1)
        @course_ware_reading_31 = @course_ware_3.course_ware_readings.by_user(@user_1).first
        @course_ware_4.set_read_by!(@user_1)
        @course_ware_reading_41 = @course_ware_4.course_ware_readings.by_user(@user_1).first
      
        # 提问问题
        @question_2 = FactoryGirl.create(:question, :model => @course_ware_3, :creator => @user_1)
      
        # 做练习
        @practice_3.submit_by_user(@user_1)
        @practice_record_31 = @practice_3.records.where(:user_id => @user_1).first
        @practice_4.submit_by_user(@user_1)
        @practice_record_41 = @practice_4.records.where(:user_id => @user_1).first



        # user_2 在 course_1 操作
        # 学习课件
        @course_ware_1.set_read_by!(@user_2)
        @course_ware_reading_12 = @course_ware_1.course_ware_readings.by_user(@user_2).first
        @course_ware_2.set_read_by!(@user_2)
        @course_ware_reading_22 = @course_ware_2.course_ware_readings.by_user(@user_2).first
      
        # 提问问题
        @question_3 = FactoryGirl.create(:question, :model => @course_ware_1, :creator => @user_2)
      
        # 做练习
        @practice_1.submit_by_user(@user_2)
        @practice_record_12 = @practice_1.records.where(:user_id => @user_2).first
        @practice_2.submit_by_user(@user_2)
        @practice_record_22 = @practice_2.records.where(:user_id => @user_2).first



        # user_2 在 course_2 操作
        # 学习课件
        @course_ware_3.set_read_by!(@user_2)
        @course_ware_reading_32 = @course_ware_3.course_ware_readings.by_user(@user_2).first
        @course_ware_4.set_read_by!(@user_2)
        @course_ware_reading_42 = @course_ware_4.course_ware_readings.by_user(@user_2).first
      
        # 提问问题
        @question_4 = FactoryGirl.create(:question, :model => @course_ware_3, :creator => @user_2)
      
        # 做练习
        @practice_3.submit_by_user(@user_2)
        @practice_record_32 = @practice_3.records.where(:user_id => @user_2).first
        @practice_4.submit_by_user(@user_2)
        @practice_record_42 = @practice_4.records.where(:user_id => @user_2).first
      }

      it{
        @user_1.course_feed_timeline_db.map(&:to).should == [
          @practice_record_41, @practice_record_31,
          @question_2,
          @course_ware_reading_41, @course_ware_reading_31,
          @practice_record_21, @practice_record_11,
          @question_1,
          @course_ware_reading_21, @course_ware_reading_11
        ]
      }

      it{
        @user_2.course_feed_timeline_db.map(&:to).should == [
          @practice_record_42, @practice_record_32,
          @question_4,
          @course_ware_reading_42, @course_ware_reading_32,
          @practice_record_22, @practice_record_12,
          @question_3,
          @course_ware_reading_22, @course_ware_reading_12
        ]
      }

      it{
        @course_1.course_feed_timeline_db.map(&:to).should == [
          @practice_record_22, @practice_record_12,
          @question_3,
          @course_ware_reading_22, @course_ware_reading_12,
          @practice_record_21, @practice_record_11,
          @question_1, 
          @course_ware_reading_21, @course_ware_reading_11
        ]
      }

      it{
        @course_2.course_feed_timeline_db.map(&:to).should == [
          @practice_record_42, @practice_record_32,
          @question_4,
          @course_ware_reading_42, @course_ware_reading_32,
          @practice_record_41, @practice_record_31,
          @question_2,
          @course_ware_reading_41, @course_ware_reading_31
        ]
      }
      
      it{
        @user_1.course_feed_timeline.map(&:to).should == [
          @practice_record_41, @practice_record_31,
          @question_2,
          @course_ware_reading_41, @course_ware_reading_31,
          @practice_record_21, @practice_record_11,
          @question_1,
          @course_ware_reading_21, @course_ware_reading_11
        ]
      }

      it{
        @user_2.course_feed_timeline.map(&:to).should == [
          @practice_record_42, @practice_record_32,
          @question_4,
          @course_ware_reading_42, @course_ware_reading_32,
          @practice_record_22, @practice_record_12,
          @question_3,
          @course_ware_reading_22, @course_ware_reading_12
        ]
      }

      it{
        @course_1.course_feed_timeline.map(&:to).should == [
          @practice_record_22, @practice_record_12,
          @question_3,
          @course_ware_reading_22, @course_ware_reading_12,
          @practice_record_21, @practice_record_11,
          @question_1, 
          @course_ware_reading_21, @course_ware_reading_11
        ]
      }

      it{
        @course_2.course_feed_timeline.map(&:to).should == [
          @practice_record_42, @practice_record_32,
          @question_4,
          @course_ware_reading_42, @course_ware_reading_32,
          @practice_record_41, @practice_record_31,
          @question_2,
          @course_ware_reading_41, @course_ware_reading_31
        ]
      }
    end
  end


end
