require 'spec_helper'

describe CourseInteractive do
  before{
    @course = FactoryGirl.create(:course)
    @user = FactoryGirl.create(:user)

    @chapter_1 = FactoryGirl.create(:chapter, :course => @course)
    @chapter_2 = FactoryGirl.create(:chapter, :course => @course)
    @chapter_3 = FactoryGirl.create(:chapter, :course => @course)

    Question.create(:title=>"title_1", :content => 'content_1', :creator => @user, :chapter_id => @chapter_1.id)
    Question.create(:title=>"title_2", :content => 'content_2', :creator => @user, :chapter_id => @chapter_2.id)

    Timecop.travel(Time.now - 2.day) do
      Question.create(:title=>"title_3", :content => 'content_3', :creator => @user, :chapter_id => @chapter_3.id)
    end

    Question.create(:title=>"title_4", :content => 'content_4', :creator => @user)

    @date = Time.now.strftime("%Y%m%d").to_i
  }

  it{
    @course.today_chapter_question_count.should == 2
  }

  it{
    @course.calculate_today_interactive_sum.should == 2
  }

  it{
    Timecop.travel(Time.now - 2.day) do
      @course.query_interactive_sum(@date).should == 2
    end
  }


  describe '有人课程签到' do
    before{
      user_1 = FactoryGirl.create(:user)
      user_2 = FactoryGirl.create(:user)
      user_3 = FactoryGirl.create(:user)
      @course.sign(user_1)
      @course.sign(user_2)
      @course.sign(user_3)
    }

    it{
      @course.calculate_today_interactive_sum.should == 5
    }

    it{
      Timecop.travel(Time.now - 2.day) do
        @course.query_interactive_sum(@date).should == 5
      end
    }
    describe '逐步增加课程交互数' do
      it{
        @course.query_interactive_sum(@date).should == 5
      }

      describe '创建指定了章节的问题' do
        before{
          @new_chapter = FactoryGirl.create(:chapter, :course => @course)

          Question.create(:title=>"title_new", :content => 'content_new', :creator => @user, :chapter_id => @new_chapter.id)
        }

        it{
          @course.query_interactive_sum(@date).should == 6
        }

        describe '有人签到' do
          before{
            user_1 = FactoryGirl.create(:user)
            user_2 = FactoryGirl.create(:user)
            @course.sign(user_1)
            @course.sign(user_2)
          }

          it{
            @course.query_interactive_sum(@date).should == 8     
          }
        end
      end
    end
  end

end