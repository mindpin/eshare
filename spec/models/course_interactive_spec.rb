require 'spec_helper'

describe CourseInteractive do
  before{
    @course = FactoryGirl.create(:course)

    @chapter_1 = FactoryGirl.create(:chapter, :course => @course)
    @chapter_2 = FactoryGirl.create(:chapter, :course => @course)
    @chapter_3 = FactoryGirl.create(:chapter, :course => @course)

    @question_1 = FactoryGirl.create(:question, :chapter => @chapter_1)
    @question_2 = FactoryGirl.create(:question, :chapter => @chapter_2)

    Timecop.travel(Time.now - 2.day) do
      @question_3 = FactoryGirl.create(:question, :chapter => @chapter_3)
    end

    @question_4 = FactoryGirl.create(:question)

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
      raise "需要准备 当天签到人数是3 的数据"
    }

    it{
      @course.calculate_today_interactive_sum.should == 5
    }

    it{
      Timecop.travel(Time.now - 2.day) do
        @course.query_interactive_sum(@date).should == 5
      end
    }
  end

  describe '逐步增加课程交互数' do
    it{
      @course.query_interactive_sum(@date).should == 5
    }

    describe '创建指定了章节的问题' do
      before{
        @new_chapter = FactoryGirl.create(:chapter, :course => @course)
        @new_question = FactoryGirl.create(:question, :chapter => @new_chapter)
      }

      it{
        @course.query_interactive_sum(@date).should == 6
      }

      describe '有人签到' do
        before{
          raise '有两人签到'
        }

        it{
          @course.query_interactive_sum(@date).should == 8     
        }
      end
    end
  end
end