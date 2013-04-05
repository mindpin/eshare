require 'spec_helper'

describe QuestionsController do
  render_views

  before {
    @user = FactoryGirl.create :user
    sign_in @user

    10.times do
      FactoryGirl.create :question
    end
  }

  context '#index' do
    before {
      get :index
    }

    it {
      response.body.should have_css('h1', :text => t('page.questions.index'))
    }

    it {
      response.body.should have_css('.questions-feeds .feed', :count => 10)
    }

    it {
      response.body.should have_css('a', :text => Question.last.title)
    }

    context '有人回答问题' do
      before {
        answer = @user.answers.create :question => Question.last,
                                      :content => '我认为……'
        get :index
      }

      it {
        Answer.count.should == 1
      }

      it {
        response.body.should have_css('.questions-feeds .feed', :count => 11)
      }
    end

    context '有人对回答投票' do
      before {
        @answer = @user.answers.create :question => Question.last,
                                      :content => '我认为……'

        @user1 = FactoryGirl.create :user
        @answer.vote_up_by!(@user1)

        get :index
      }

      it {
        Answer.last.vote_sum.should == 1
      }

      it {
        response.body.should have_css('.questions-feeds .feed', :count => 12)
      }

      context '反复投票和取消' do
        it {
          @answer.vote_down_by!(@user1)
          get :index
          response.body.should have_css('.questions-feeds .feed', :count => 11)
          # feed 不显示反对票
        }

        it {
          @answer.vote_cancel_by!(@user1)
          get :index
          response.body.should have_css('.questions-feeds .feed', :count => 11)
          # feed 不显示取消投票
        }
      end
    end


  end

  context '#show' do
    before {
      get :show, :id => Question.last.id
    }

    it {
      response.body.should have_css('.page-question-show')
    }

    it '第一次进来，能看到回答框' do
      response.body.should have_css('textarea#answer_content')
    end

    context '回答过后，就看不到回复框了' do 
      before {
        answer = FactoryGirl.create :answer, :question => Question.last,
                                             :creator => @user
        get :show, :id => Question.last.id
      }

      it {
        response.body.should_not have_css('textarea#answer_content')
      }

      it {
        response.body.should have_css('.you-can-answer-only-once')
      }

      it {
        response.body.should have_css('a', :text => t('common.question.your-answer'))
      }
    end
  end
end