require 'spec_helper'

describe CourseReadPercent do
  context 'db' do
    before{
      @course = FactoryGirl.create(:course)

      @chapter_1 = FactoryGirl.create(:chapter, :course => @course)
      @chapter_2 = FactoryGirl.create(:chapter, :course => @course)

      @course_ware_1 = FactoryGirl.create :course_ware, :chapter => @chapter_1

      @course_ware_2 = FactoryGirl.create :course_ware, :chapter => @chapter_1,
                                                        :total_count => 7

      @course_ware_3 = FactoryGirl.create :course_ware, :chapter => @chapter_2

      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)
    }

    it {
      @course.read_percent_db(@user_1).should == "0%"
    }

    it {
      @chapter_1.read_percent_db(@user_1).should == "0%"
    }

    it {
      @course_ware_1.read_percent_db(@user_1).should == "0%"
    }

    describe '把一个课件标记为阅读' do
      before{
        @course_ware_1.set_read_by!(@user_1)
      }

      it {
        @course_ware_1.read_percent_db(@user_1).should == "100%"
      }

      it {
        @chapter_1.read_percent_db(@user_1).should == "50%"
      }

      it {
        @chapter_2.read_percent_db(@user_1).should == "0%"
      }
       
      it { 
        @course.read_percent_db(@user_1).should == "33%"
      }

      describe '阅读另一个课件' do
        before{
          @course_ware_2.update_read_count_of(@user_1, 3)
        }

        it {
          @course_ware_2.read_percent_db(@user_1).should == "43%"
        }

        it {
          @chapter_1.read_percent_db(@user_1).should == "72%"
        }

        it {
          @course.read_percent_db(@user_1).should == "48%"
        }

        it{
          @course_ware_2.read_percent_db(@user_2).should == "0%"

          @chapter_1.read_percent_db(@user_2).should == "0%"

          @course.read_percent_db(@user_2).should == "0%"
        }

        describe '改变 total_count' do
          before{
            @course_ware_2.update_attributes(:total_count => 10)
          }

          # 改变 total_count 不会导致已学习的百分比发生改变
          # TODO 需要以其他方法处理修改 total_count 后的逻辑

          # it {
          #   @course_ware_2.read_percent_db(@user_1).should == "30%"
          #   @course_ware_2.read_percent(@user_1).should == "30%"
          # }

          # it {
          #   @chapter_1.read_percent_db(@user_1).should == "65%"
          #   @chapter_1.read_percent(@user_1).should == "65%"
          # }

          # it {
          #   @course.read_percent_db(@user_1).should == "43%"
          #   @course.read_percent(@user_1).should == "43%"
          # }
        end
      end
    end
  end

  context 'redis' do
    it{
      @course = FactoryGirl.create(:course)

      @chapter_1 = FactoryGirl.create(:chapter, :course => @course)
      @chapter_2 = FactoryGirl.create(:chapter, :course => @course)

      @course_ware_1 = FactoryGirl.create :course_ware, :chapter => @chapter_1

      @course_ware_2 = FactoryGirl.create :course_ware, :chapter => @chapter_1,
                                                        :total_count => 7

      @course_ware_3 = FactoryGirl.create :course_ware, :chapter => @chapter_2

      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)

      @course.read_percent(@user_1).should == "0%"
      @chapter_1.read_percent(@user_1).should == "0%"
      @course_ware_1.read_percent(@user_1).should == "0%"


      # 把一个课件标记为阅读
      @course_ware_1.set_read_by!(@user_1)

      @course_ware_1.read_percent(@user_1).should == "100%"
      @chapter_1.read_percent(@user_1).should == "50%"
      @chapter_2.read_percent(@user_1).should == "0%"
      @course.read_percent(@user_1).should == "33%"


      # 阅读另一个课件
      @course_ware_2.update_read_count_of(@user_1, 3)

      @course_ware_2.read_percent(@user_1).should == "43%"
      @chapter_1.read_percent(@user_1).should == "72%"
      @course.read_percent(@user_1).should == "48%"
      @course_ware_2.read_percent(@user_2).should == "0%"
      @chapter_1.read_percent(@user_2).should == "0%"
      @course.read_percent(@user_2).should == "0%"
    }
  end
end