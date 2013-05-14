require "spec_helper"

describe SelectCourseApply do
  let(:user){FactoryGirl.create(:user)}
  let(:user1){FactoryGirl.create(:user)}
  let(:course){FactoryGirl.create(:course)}
  let(:course1){FactoryGirl.create(:course)}


  describe '#apply_select_courses  1 查询用户"选了"的课程列表' do
    it {
      user.select_course(course)
      user.apply_select_courses.count.should  == 1  
    }

    it {
      user.apply_select_courses.count.should == 0
    }
  end

  describe '#selected_courses  2 查询用户“选中”的课程列表' do
    it {
      user.select_course(course)
      user.select_course_applies.by_course(course).first.update_attributes :status => 'ACCEPT'
      user.selected_courses.count.should  == 1
    }

    it {
      user.select_course(course)
      user.selected_courses.count.should  == 0  
    }

    it {
      user1.select_course(course)
      user.selected_courses.count.should  == 0
    }
  end

  describe '#is_apply_select?(user)  3 判断一个用户是否“选了”某门课' do
    it {
      user.select_course(course)
      course.is_apply_select?(user).should == true
    }

    it {
      user1.select_course(course)
      course.is_apply_select?(user).should == false
    }
  end

  describe '#is_selected?(user)  4 判断一个用户是否"选中"某门课' do
    it {
      user.select_course(course)
      course.is_selected?(user).should == false
    }

    it {
      user.select_course(course)
      course.is_selected?(user).should == false 
    }

    it {
      user1.select_course(course)
      course.is_selected?(user).should == false
    }
  end

  describe '#apply_select_users  5 查询课程被哪些用户“选了”' do
    it {
      user.select_course(course)
      user1.select_course(course)
      course.apply_select_users.count.should  == 2  
    }

    it {
      course.apply_select_users.count.should == 0
    }
  end

  describe '#selected_users  6 查询课程被哪些用户“选中”' do
    it {
      user.select_course(course)
      user.select_course_applies.by_course(course).first.update_attributes :status => 'ACCEPT'
      course.selected_users.count.should  == 1
    }

    it {
      user.select_course(course)
      course.selected_users.count.should  == 0  
    }

    it {
      user1.select_course(course)
      course.selected_users.count.should  == 0
    }
  end

  describe '#select_course(course) 7 用户发起一个选课请求' do
    it { 
      expect {
        user.select_course(course)
      }.to change {
        SelectCourseApply.all.count
      }.by(1) 
    }

    it { 
      expect {
        user.select_course(course)
        user.select_course(course)
      }.to change {
        SelectCourseApply.all.count
      }.by(1) 
    }
  end


  describe '#request_select_course_applies 8 查询一个课程的所有”没有处理“的选课请求' do
    it {
      user.select_course(course)
      course.request_select_course_applies.count.should  == 1  
    }

    it {
      course1.request_select_course_applies.count.should == 0
    }
  end

end