SimpleNavbar::Base.config do
  rule :admin do
    nav :home, :name => '首页', :url => '/admin' do
      controller :'admin/index'
    end

    nav :users, :name => '用户管理', :url => '/admin/users' do
      controller :'admin/users'
    end

    nav :teams, :name => '班级管理', :url => '/admin/teams' do
      controller :'admin/teams'
    end

    nav :courses, :name => '课程管理', :url => '/admin/courses' do
      controller :'admin/courses'
      controller :'admin/course_teachers'
    end

    nav :course_score_records, :name => '成绩管理', :url => '/admin/course_score_records' do
      controller :'admin/course_score_records'
    end

    nav :course_surveys, :name => '课堂教学评价', :url => '/admin/course_surveys' do
      controller :'admin/course_surveys'
    end

    nav :categories, :name => '资源分类管理', :url => '/admin/categories' do
      controller :'admin/categories'
    end

    nav :announcements, :name => '公告', :url => '/admin/announcements' do
      controller :'admin/announcements'
    end
  end

  # -------------------------
  # 教师
  rule :teacher do
    nav :dashboard, :name => '首页', :url => '/dashboard' do
      controller :index, :only => :dashboard
    end

    nav :disk, :name => '我的文件夹', :url => '/disk' do
      controller :disk
    end

    nav :courses, :name => '课程', :url => '/courses' do
      controller :courses
    end
  end

  # ------------------
  # 学生
  rule :student do
    nav :dashboard, :name => '课程首页', :url => '/dashboard' do
      controller :index, :only => :dashboard
    end

    nav :disk, :name => '我的文件夹', :url => '/disk' do
      controller :disk
    end
  end

end
