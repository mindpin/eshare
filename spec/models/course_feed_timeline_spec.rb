require 'spec_helper'

describe CourseFeedTimelime do
  context 'db' do
    before{
      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)

      @course_1 = FactoryGirl.create(:course)
      chapter_1 = FactoryGirl.create(:chapter, :course => @course_1)
      @course_ware_1 = FactoryGirl.create(:course_ware, :chapter => chapter_1)
      @course_ware_2 = FactoryGirl.create(:course_ware, :chapter => chapter_1)

      @course_2 = FactoryGirl.create(:course)
      chapter_2 = FactoryGirl.create(:chapter, :course => @course_2)
      @course_ware_3 = FactoryGirl.create(:course_ware, :chapter => chapter_2)
      @course_ware_4 = FactoryGirl.create(:course_ware, :chapter => chapter_2)
    }

    it{
      @course_1.course_feed_timeline_db.should == []
      @course_2.course_feed_timeline_db.should == []
      @user_1.course_feed_timeline_db.should == []
      @user_2.course_feed_timeline_db.should == []
    }

    context 'user_1 在 course_1 操作' do
      before{
        # 学习课件
        @course_ware_1.set_read_by!(@user_1)
        @course_ware_reading_11 = @course_ware_1.course_ware_readings.by_user(@user_1).first
        @course_ware_2.set_read_by!(@user_1)
        @course_ware_reading_21 = @course_ware_2.course_ware_readings.by_user(@user_1).first
        # 提问问题
        @question_1 = FactoryGirl.create(:question, :course_ware => @course_ware_1, :creator => @user_1)
        
      }

      it{
        @course_2.course_feed_timeline_db.should == []
        @user_2.course_feed_timeline_db.should == []
      }

      it{
        @course_1.course_feed_timeline_db.map(&:to).should == [
          @question_1, @course_ware_reading_21, @course_ware_reading_11
        ]
      }

      it{
        @user_1.course_feed_timeline_db.map(&:to).should == [
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
          @question_2 = FactoryGirl.create(:question, :course_ware => @course_ware_3, :creator => @user_1)
        

          # user_2 在 course_1 操作
          # 学习课件
          @course_ware_1.set_read_by!(@user_2)
          @course_ware_reading_12 = @course_ware_1.course_ware_readings.by_user(@user_2).first
          @course_ware_2.set_read_by!(@user_2)
          @course_ware_reading_22 = @course_ware_2.course_ware_readings.by_user(@user_2).first
        
          # 提问问题
          @question_3 = FactoryGirl.create(:question, :course_ware => @course_ware_1, :creator => @user_2)
        

          # user_2 在 course_2 操作
          # 学习课件
          @course_ware_3.set_read_by!(@user_2)
          @course_ware_reading_32 = @course_ware_3.course_ware_readings.by_user(@user_2).first
          @course_ware_4.set_read_by!(@user_2)
          @course_ware_reading_42 = @course_ware_4.course_ware_readings.by_user(@user_2).first
        
          # 提问问题
          @question_4 = FactoryGirl.create(:question, :course_ware => @course_ware_3, :creator => @user_2)
        
        }

        it{
          @user_1.course_feed_timeline_db.map(&:to).should == [
            @question_2,
            @course_ware_reading_41, @course_ware_reading_31,
            @question_1,
            @course_ware_reading_21, @course_ware_reading_11
          ]
        }

        it{
          @user_2.course_feed_timeline_db.map(&:to).should == [
            @question_4,
            @course_ware_reading_42, @course_ware_reading_32,
            @question_3,
            @course_ware_reading_22, @course_ware_reading_12
          ]
        }

        it{
          @course_1.course_feed_timeline_db.map(&:to).should == [
            @question_3,
            @course_ware_reading_22, @course_ware_reading_12,
            @question_1, 
            @course_ware_reading_21, @course_ware_reading_11
          ]
        }

        it{
          @course_2.course_feed_timeline_db.map(&:to).should == [
            @question_4,
            @course_ware_reading_42, @course_ware_reading_32,
            @question_2,
            @course_ware_reading_41, @course_ware_reading_31
          ]
        }
        
      end
    end
  end

  context 'redis' do
    it{
      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)

      @course_1 = FactoryGirl.create(:course)
      chapter_1 = FactoryGirl.create(:chapter, :course => @course_1)
      @course_ware_1 = FactoryGirl.create(:course_ware, :chapter => chapter_1)
      @course_ware_2 = FactoryGirl.create(:course_ware, :chapter => chapter_1)

      @course_2 = FactoryGirl.create(:course)
      chapter_2 = FactoryGirl.create(:chapter, :course => @course_2)
      @course_ware_3 = FactoryGirl.create(:course_ware, :chapter => chapter_2)
      @course_ware_4 = FactoryGirl.create(:course_ware, :chapter => chapter_2)
      
      @course_1.course_feed_timeline.should == []
      @course_2.course_feed_timeline.should == []
      @user_1.course_feed_timeline.should == []
      @user_2.course_feed_timeline.should == []
      

      ## user_1 在 course_1 操作
      # 学习课件
      @course_ware_1.set_read_by!(@user_1)
      @course_ware_reading_11 = @course_ware_1.course_ware_readings.by_user(@user_1).first
      @course_ware_2.set_read_by!(@user_1)
      @course_ware_reading_21 = @course_ware_2.course_ware_readings.by_user(@user_1).first
      # 提问问题
      @question_1 = FactoryGirl.create(:question, :course_ware => @course_ware_1, :creator => @user_1)
      

      @course_2.course_feed_timeline.should == []
      @user_2.course_feed_timeline.should == []

      @course_1.course_feed_timeline.map(&:to).should == [
        @question_1, @course_ware_reading_21, @course_ware_reading_11
      ]

      @user_1.course_feed_timeline.map(&:to).should == [
        @question_1, @course_ware_reading_21, @course_ware_reading_11
      ]

      # user_1 在 course_2 操作
      # 学习课件
      @course_ware_3.set_read_by!(@user_1)
      @course_ware_reading_31 = @course_ware_3.course_ware_readings.by_user(@user_1).first
      @course_ware_4.set_read_by!(@user_1)
      @course_ware_reading_41 = @course_ware_4.course_ware_readings.by_user(@user_1).first
    
      # 提问问题
      @question_2 = FactoryGirl.create(:question, :course_ware => @course_ware_3, :creator => @user_1)
    

      # user_2 在 course_1 操作
      # 学习课件
      @course_ware_1.set_read_by!(@user_2)
      @course_ware_reading_12 = @course_ware_1.course_ware_readings.by_user(@user_2).first
      @course_ware_2.set_read_by!(@user_2)
      @course_ware_reading_22 = @course_ware_2.course_ware_readings.by_user(@user_2).first
    
      # 提问问题
      @question_3 = FactoryGirl.create(:question, :course_ware => @course_ware_1, :creator => @user_2)
    

      # user_2 在 course_2 操作
      # 学习课件
      @course_ware_3.set_read_by!(@user_2)
      @course_ware_reading_32 = @course_ware_3.course_ware_readings.by_user(@user_2).first
      @course_ware_4.set_read_by!(@user_2)
      @course_ware_reading_42 = @course_ware_4.course_ware_readings.by_user(@user_2).first
    
      # 提问问题
      @question_4 = FactoryGirl.create(:question, :course_ware => @course_ware_3, :creator => @user_2)
    
      
      @user_1.course_feed_timeline.map(&:to).should == [
        @question_2,
        @course_ware_reading_41, @course_ware_reading_31,
        @question_1,
        @course_ware_reading_21, @course_ware_reading_11
      ]

      @user_2.course_feed_timeline.map(&:to).should == [
        @question_4,
        @course_ware_reading_42, @course_ware_reading_32,
        @question_3,
        @course_ware_reading_22, @course_ware_reading_12
      ]
      
      @course_1.course_feed_timeline.map(&:to).should == [
        @question_3,
        @course_ware_reading_22, @course_ware_reading_12,
        @question_1, 
        @course_ware_reading_21, @course_ware_reading_11
      ]

      @course_2.course_feed_timeline.map(&:to).should == [
        @question_4,
        @course_ware_reading_42, @course_ware_reading_32,
        @question_2,
        @course_ware_reading_41, @course_ware_reading_31
      ]
    }
  end
end
