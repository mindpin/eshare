require 'spec_helper'

describe CourseReadPercent do
  before{
    @course = FactoryGirl.create(:course)

    @chapter = FactoryGirl.create(:chapter, :course => @course)
    FactoryGirl.create(:chapter, :course => @course)

    @course_ware_1 = FactoryGirl.create :course_ware, :chapter => @chapter
    @course_ware_2 = FactoryGirl.create :course_ware, :chapter => @chapter,
                                        :total_count => 7

    @user_1 = FactoryGirl.create(:user)
    @user_2 = FactoryGirl.create(:user)
  }

  it{
    @course.read_percent_db(@user_1).should == "0%"
    @course.read_percent(@user_1).should == "0%"

    @chapter.read_percent_db(@user_1).should == "0%"
    @chapter.read_percent(@user_1).should == "0%"

    @course_ware_1.read_percent_db(@user_1).should == "0%"
    @course_ware_1.read_percent(@user_1).should == "0%"
  }

  describe '把一个课件标记为阅读' do
    before{
      @course_ware_1.set_read_by!(@user_1)
    }

    it{
      @course_ware_1.read_percent_db(@user_1).should == "100%"
      @course_ware_1.read_percent(@user_1).should == "100%"

      @chapter.read_percent_db(@user_1).should == "50%"
      @chapter.read_percent(@user_1).should == "50%"
      
      @course.read_percent_db(@user_1).should == "25%"
      @course.read_percent(@user_1).should == "25%"
    }

    describe '阅读另一个课件' do
      before{
        @course_ware_2.update_read_count_of(@user_1, 3)
      }

      it{
        @course_ware_2.read_percent_db(@user_1).should == "43%"
        @course_ware_2.read_percent(@user_1).should == "43%"

        @chapter.read_percent_db(@user_1).should == "72%"
        @chapter.read_percent(@user_1).should == "72%"

        @course.read_percent_db(@user_1).should == "36%"
        @course.read_percent(@user_1).should == "36%"
      }

      it{
        @course_ware_2.read_percent_db(@user_2).should == "0%"
        @course_ware_2.read_percent(@user_2).should == "0%"

        @chapter.read_percent_db(@user_2).should == "0%"
        @chapter.read_percent(@user_2).should == "0%"

        @course.read_percent_db(@user_2).should == "0%"
        @course.read_percent(@user_2).should == "0%"
      }

      describe '改变 total_count' do
        before{
          @course_ware_2.update_attributes(:total_count => 10)
        }

        it{
          @course_ware_2.read_percent_db(@user_1).should == "30%"
          @course_ware_2.read_percent(@user_1).should == "30%"

          @chapter.read_percent_db(@user_1).should == "65%"
          @chapter.read_percent(@user_1).should == "65%"

          @course.read_percent_db(@user_1).should == "33%"
          @course.read_percent(@user_1).should == "33%"
        }
      end
    end
  end

end