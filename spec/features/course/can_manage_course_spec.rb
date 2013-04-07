require 'spec_helper'

feature '创建课程' do
  background do
    @user = FactoryGirl.create :user, :login => 'teacher1', :password => '1234'

    visit '/'
    fill_in 'user_login', :with => 'teacher1'
    fill_in 'user_password', :with => '1234'
    click_button '登录'
  end

  context '创建课程' do
    before {
      within '.page-sidebar' do
        click_on '课程管理'
      end
      click_on '创建课程'
    }

    it {
      click_on I18n.t('common.form.cancel')
      current_path.should == '/manage/courses'
    }

    context '正确的参数' do
      before {
        fill_in 'course_name', :with => '测试课程'
        fill_in 'course_cid', :with => '0002'
        fill_in 'course_desc', :with => '测试课程的描述信息'
        click_on '创建课程'
      }

      it {
        Course.count.should == 1
      }

      it {
        Course.last.name.should == '测试课程'
      }

      it {
        current_path.should == '/manage/courses'
      }
    end

    context '错误的参数，通不过校验' do
      before {
        old_course = FactoryGirl.create :course, :cid => '0001'
      }

      context '字段未填' do
        it {
          expect {
            click_on '创建课程'
          }.to change{ 
            Course.count
          }.by(0)
        }

        it {
          click_on '创建课程'
          page.should have_css('.field_with_errors input#course_name', :count => 1)
          page.should have_css('.field_with_errors input#course_cid', :count => 1)
        }

        it {
          click_on '创建课程'
          page.should_not have_content('translation missing')
        }
      end

      context '名称，序号重复' do
        before {
          fill_in 'course_name', :with => '测试课程'
          fill_in 'course_cid', :with => '0001'
        }

        it {
          expect {
            click_on '创建课程'
          }.to change{ 
            Course.count
          }.by(0)
        }

        it {
          click_on '创建课程'
          page.should have_css('.field_with_errors input#course_cid', :count => 1)
        }

        it {
          click_on '创建课程'
          page.should_not have_content('translation missing')
        }
      end
    end
  end
end