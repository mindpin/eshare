require 'spec_helper'

feature '访问个人网盘文件夹' do
  background do
    @user = User.create :login => 'teacher1',
                        :email => 'admin@admin.com',
                        :password => '1234',
                        :role => :teacher
    visit '/'
    fill_in 'user_login', :with => 'teacher1'
    fill_in 'user_password', :with => '1234'
    click_button '登录'

    visit '/disk'
  end

  it do
    current_path.should == '/disk'
  end

  it {
    page.should have_content '所有文件'
  }
end

feature '上传文件' do
  background do
    @user = User.create :login => 'teacher1',
                        :email => 'admin@admin.com',
                        :password => '1234',
                        :role => :teacher
    visit '/'
    fill_in 'user_login', :with => 'teacher1'
    fill_in 'user_password', :with => '1234'
    click_button '登录'

    visit '/disk'
  end

  it {
    page.should have_content '上传文件'
  }
end