require 'spec_helper'

describe '教师使用问答功能' do
  before {
    20.times do
      FactoryGirl.create :question
    end
  }

  before {
    @teacher_user = User.create :login => 'teacher1',
                        :email => 'admin@admin.com',
                        :password => '1234',
                        :role => :teacher
    visit '/'
    fill_in 'user_login', :with => 'teacher1'
    fill_in 'user_password', :with => '1234'
    click_button '登录'
  }

  context {
    before {
      click_on '问答'
      # click_on '所有问题'
    }

    it {
      current_path.should == '/questions'
    }

    it {
      page.should have_css('.page-questions-index')
    }

    it {
      page.should have_css('h1', :text => t('page.questions.index'))
    }

    it {
      Question.count.should == 20
    }

    it {
      page.should have_css('.questions .question', :count => 20)
    }
  }

end