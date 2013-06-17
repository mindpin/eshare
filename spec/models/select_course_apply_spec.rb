require "spec_helper"

describe SelectCourseApply do
  let(:user){FactoryGirl.create(:user)}
  let(:user1){FactoryGirl.create(:user)}
  let(:user2){FactoryGirl.create(:user)}
  let(:user3){FactoryGirl.create(:user)}
  let(:course){FactoryGirl.create :course, :apply_request_limit => 4}
  let(:course1){FactoryGirl.create(:course)}


  describe '#request_selected_courses  1 查询用户"选了"的课程列表' do
    it {
      user.select_course(course)
      user.request_selected_courses.count.should  == 1  
    }

    it {
      user.request_selected_courses.count.should == 0
    }
  end

  describe '#accept_selected_courses  2 查询用户“选中”的课程列表' do
    it {
      user.select_course(course)
      user.select_course_applies.by_course(course).first.update_attributes :status => 'ACCEPT'
      user.accept_selected_courses.count.should  == 1
    }

    it {
      user.select_course(course)
      user.accept_selected_courses.count.should  == 0  
    }

    it {
      user1.select_course(course)
      user.accept_selected_courses.count.should  == 0
    }
  end

  describe '#is_request_selected_by?(user)  3 判断一个用户是否“选了”某门课' do
    it {
      user.select_course(course)
      course.is_request_selected_by?(user).should == true
    }

    it {
      user1.select_course(course)
      course.is_request_selected_by?(user).should == false
    }
  end

  describe '#is_accept_selected_by?(user)  4 判断一个用户是否"选中"某门课' do
    it {
      user.select_course(course)
      course.is_accept_selected_by?(user).should == false
    }

    it {
      user.select_course(course)
      course.is_accept_selected_by?(user).should == false 
    }

    it {
      user1.select_course(course)
      course.is_accept_selected_by?(user).should == false
    }
  end

  describe '#request_selected_users  5 查询课程被哪些用户“选了”' do
    it {
      user.select_course(course)
      user1.select_course(course)
      course.request_selected_users.count.should  == 2  
    }

    it {
      course.request_selected_users.count.should == 0
    }
  end

  describe '#accept_selected_users  6 查询课程被哪些用户“选中”' do
    it {
      user.select_course(course)
      user.select_course_applies.by_course(course).first.update_attributes :status => 'ACCEPT'
      course.accept_selected_users.count.should  == 1
    }

    it {
      user.select_course(course)
      course.accept_selected_users.count.should  == 0  
    }

    it {
      user1.select_course(course)
      course.accept_selected_users.count.should  == 0
    }
  end

  describe '#apply_request_is_full?  查询是否已经到达选课人数上限' do
    it {
      course.have_apply_request_limit?.should == true
    }

    it {
      course.remaining_apply_request_count.should == 4
    }

    it {
      course.apply_request_limit.should == 4
    }

    it {
      user1.select_course(course)
      user.select_course(course)
      course.apply_request_is_full?.should  == false
    }
    it {
      user1.select_course(course1)
      user2.select_course(course1)
      user3.select_course(course1)
      user.select_course(course1)
      course1.apply_request_is_full?.should  == false
    }
    it {
      user1.select_course(course)
      user2.select_course(course)
      user3.select_course(course)
      user.select_course(course)
      user.select_course_applies.by_course(course).first.update_attributes :status => 'ACCEPT'
      course.apply_request_is_full?.should  == true
    }
  end

  describe '#remaining_apply_request_count  查询现在还有多少选课名额' do
    it {
      user1.select_course(course)
      user.select_course(course)
      course.remaining_apply_request_count.should  == 2
    }
    it {
      user1.select_course(course1)
      user.select_course(course1)
      course1.remaining_apply_request_count.should  == -1
    }

    it {
      user1.select_course(course)
      user2.select_course(course)
      user3.select_course(course)
      user.select_course(course)
      user.select_course_applies.by_course(course).first.update_attributes :status => 'ACCEPT'
      course.remaining_apply_request_count.should  == 0
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

    it { 
      expect {
        user.select_course(course)
        user.select_course_applies.by_course(course).first.update_attributes :status => 'REJECT'
        user.select_course(course)
      }.to change {
        user.request_selected_courses.all.count
      }.by(1)
    }

    context '#到达选课人数上限' do
      before do
        user.select_course(course)
        user1.select_course(course)
        user2.select_course(course)
        user3.select_course(course)
        @user4 = FactoryGirl.create(:user)
      end
      it { @user4.select_course(course).should  == false }
    end
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