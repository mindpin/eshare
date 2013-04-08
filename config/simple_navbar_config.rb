SimpleNavbar::Base.config do
  rule :admin do
    nav :home, :url => '/admin' do
      controller :'admin/index'
    end

    nav :users_manage, :url => '/admin/users' do
      controller :'admin/users'
    end

    nav :categories_manage, :url => '/admin/categories' do
      controller :'admin/categories'
    end
  end

  # -------------------------
  # 教师
  rule :teacher do
    nav :dashboard, :url => '/dashboard' do
      controller :index, :only => :dashboard
    end

    nav :courses_manage, :url => '/manage/courses' do
      controller :'manage/courses'
      controller :'manage/chapters'
    end

    nav :disk, :url => '/disk' do
      controller :disk
    end

    nav :questions, :url => '/questions' do
      controller :questions
    end
  end

  # ------------------
  # 学生
  rule :student do
    nav :dashboard, :url => '/dashboard' do
      controller :index, :only => :dashboard
    end

    nav :courses, :url => '/courses' do
      controller :courses
      controller :chapters
    end

    nav :disk, :url => '/disk' do
      controller :disk
    end
  end

end
