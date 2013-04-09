require 'spec_helper'

describe 'question_notice' do
  before{
    @user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question)
  }

  it{
    @user.notice_questions.should == []
  }

  describe '关注的问题' do
    before{
      @question.follow_by_user(@user)
    }

    it{
      @question.followed_by?(@user).should == true
    }

    it{
      @user.notice_questions.should == []
    }

    describe '关注的问题发生变化' do
      before{
        Timecop.travel(Time.now + 1.seconds)
        @question.update_attributes(:content => '改')
      }

      it{
        @user.notice_questions.should == [@question]
      }

      it{
        Timecop.travel(Time.now + 1.seconds)
        @question.visit_by!(@user)
        @user.notice_questions.should == [] 
      }

      describe '被指定为回答者' do
        before{
          @question_1 = FactoryGirl.create(:question, :ask_to => @user)
        }

        it{
          @user.notice_questions.should == [@question_1, @question]   
        }

        it{
          @question_1.answers.create!(:content => '我是回答', :creator => @user)
          @user.notice_questions.should == [@question]   
        }

        it{
          @question.visit_by!(@user)
          @user.notice_questions.should == [@question_1]
        }

        it{
          @question_1.visit_by!(@user)
          @user.notice_questions.should == [@question_1, @question]
        }

        it{
          @question_1.answers.create!(:content => '我是回答', :creator => @user)
          @question.visit_by!(@user)
          @user.notice_questions.should == []
        }

      end
    end


  end
end