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
  end

  background {
    @file_entity = FileEntity.create({
      :attach => File.new(Rails.root.join('spec/data/upload_test_files/test1024.file'))
    })

    MediaResource.put_file_entity @user, '/README.test', @file_entity
    MediaResource.put_file_entity @user, '/config.test', @file_entity
    MediaResource.put_file_entity @user, '/yaml.test', @file_entity
  }

  context '根目录' do
    before {
      visit '/disk'
    }

    it do
      current_path.should == '/disk'
    end

    it {
      page.should have_content '所有文件'
    }

    it {
      page.should have_css('.files .list-view .file-item', :count => 3)
    }
  end
end