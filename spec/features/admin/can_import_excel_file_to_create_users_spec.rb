require 'spec_helper'

feature '管理员身份登录' do
  background do
    @user = User.create :login => 'admin',
                        :email => 'admin@admin.com',
                        :password => '1234',
                        :role => :admin
  end

  scenario '登录' do
    visit '/'
    fill_in 'user_login', :with => 'admin'
    fill_in 'user_password', :with => '1234'
    click_button '登录'

    current_path.should == '/admin'
  end

end