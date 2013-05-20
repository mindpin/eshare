require 'spec_helper'

feature '教师身份登录' do
  background do
    @user = User.create :login => 'admin',
                        :email => 'admin@admin.com',
                        :password => '1234',
                        :role => :teacher

    visit '/'
    fill_in 'user_login', :with => 'admin'
    fill_in 'user_password', :with => '1234'
    click_button '登录'
  end

  scenario '登录' do
    current_path.should == '/dashboard'
  end

  it {
    page.should have_selector('h1')
  }

  it {
    page.should have_content '首页'
  }

end