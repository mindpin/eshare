require 'spec_helper'

describe '学生身份登录' do
  before {
    10.times {
      FactoryGirl.create :course
    }

    @user = FactoryGirl.create :user, :password => '1234',
                                      :role => :student

    visit '/'
    fill_in 'user_login', :with => @user.login
    fill_in 'user_password', :with => '1234'
    click_button '登录'
  }

  it {
    current_path.should == '/dashboard'
  }

  context '访问课程页' do
    before {
      within '.page-sidebar' do
        click_on '课程'
      end
    }

    it {
      current_path.should == '/courses'
    }

    context '访问一个课程' do
      before {
        @course = Course.last

        within 'div.courses' do
          click_on @course.name
        end
      }

      it {
        current_path.should == "/courses/#{@course.id}"
      }
    end
  end

end