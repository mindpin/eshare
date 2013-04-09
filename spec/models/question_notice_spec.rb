require 'spec_helper'

describe 'question_notice' do
  before{
    @user = FactoryGril.create(:user)
    @question = FactoryGril.create(:question)
  }

  it{
    @user.notice_questions.should == []
  }

  describe '关注的问题' do
    before{
      @user.follow_question(@question)
    }

    it{
      @user.notice_questions.should == []
    }

    describe '关注的问题发生变化' do
      before{
        @question.update_attribute(:content => '改')
      }

      it{
        @user.notice_questions.should =~ [@question]
      }

      it{
        @user.visit_question!(@question)
        @user.notice_questions.should == [] 
      }

      describe '被指定为回答者，没有回答' do
        before{
          @question_1 = FactoryGril.create(:question, :ask_to => @user)
        }

        it{
          @user.notice_questions.should =~ [@question]   
        }

        it{
          @question_1.answer.create!(:content => '我是回答', :creator => @user)
          @user.notice_questions.should =~ [@question_1, @question]   
        }

        it{
          @question_1.answer.create!(:content => '我是回答', :creator => @user)
          @user.visit_question!(@question)
          @user.notice_questions.should =~ [@question_1]
        }

        it{
          @question_1.answer.create!(:content => '我是回答', :creator => @user)
          @user.visit_question!(@question_1)
          @user.notice_questions.should =~ [@question]
        }

        it{
          @question_1.answer.create!(:content => '我是回答', :creator => @user)
          @user.visit_question!(@question_1)
          @user.visit_question!(@question)
          @user.notice_questions.should == []
        }

      end
    end


  end
end