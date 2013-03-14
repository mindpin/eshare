require 'spec_helper'

feature '管理员进行用户管理' do
  background do
    @user = User.create :login => 'admin',
                        :email => 'admin@admin.com',
                        :password => '1234',
                        :role => :admin

    FactoryGirl.create :user, :teacher, :name => '狄仁杰'
    FactoryGirl.create :user, :teacher, :name => '金田一'
    FactoryGirl.create :user, :teacher, :name => '包拯'
  end

  before do
    visit '/'
    fill_in 'user_login', :with => 'admin'
    fill_in 'user_password', :with => '1234'
    click_on '登录'
  end

  context '访问用户列表' do
    before {
      visit '/admin/users'
    }

    it {
      page.should have_selector '.page-admin-users'
    }

    it {
      page.should have_content '狄仁杰'
      page.should have_content '金田一'
      page.should have_content '包拯'
    }

    it {
      page.all('.page-admin-users .user[data-role=admin]').
        length.should == 1
    }

    it {
      page.all('.page-admin-users .user[data-role=teacher]').
        length.should == 3
    }

    context '修改和删除链接' do
      it {
        page.all('.page-admin-users .user[data-role=teacher]').each do |user|
          user.should have_selector('a.edit')
          user.find('a.edit').text.should == t('common.user.edit')
        end
      }

      it {
        page.all('.page-admin-users .user[data-role=teacher]').each do |user|
          user.should have_selector('a.delete')
          user.find('a.delete').text.should == t('common.user.delete')
        end
      }
    end

    context '管理员账号没有修改和删除链接' do
      it {
        page.all('.page-admin-users .user[data-role=admin]').each do |user|
          user.should_not have_selector('a.edit')
        end
      }

      it {
        page.all('.page-admin-users .user[data-role=admin]').each do |user|
          user.should_not have_selector('a.delete')
        end
      }
    end
  end

  context '修改用户信息' do
    before {
      visit "/admin/users/#{User.last.id}/edit"
    }

    it {
      page.should have_selector '.page-admin-user-edit'
    }
  end

end