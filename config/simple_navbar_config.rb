SimpleNavbar::Base.config do
  rule :admin do
    nav :users_manage, :url => '/admin/users' do
      controller :'admin/users'
    end

    nav :courses_manage, :url => '/manage/courses' do
      controller :'manage/courses'
      controller :'manage/chapters'
      controller :'manage/course_wares'
      controller :'manage/applies'
    end

    if R::INHOUSE
      nav :surveys_manage, :url => '/manage/surveys' do
        controller :'manage/surveys'
        controller :'manage/survey_results'
      end
    end

    if R::INTERNET
      nav :user_opinions_view, :url => '/admin/user_opinions' do
        controller :'admin/user_opinions'
      end

      nav :site_changes, :url => '/admin/site_changes' do
        controller :'admin/site_changes'
      end
    end
  end

  # -------------------------
  # 教师
  rule :teacher do
    nav :courses, :url => '/courses' do
      controller :courses
      controller :chapters
      controller :course_wares
    end

    nav :dashboard, :url => '/dashboard' do
      controller :index, :only => :dashboard
    end

    nav :user, :url => '/users/me' do
      controller :users
      controller :friends
    end

    # nav :disk, :url => '/disk' do
    #   controller :disk
    # end

    nav :tags, :url => '/tags' do
      controller :tags
    end

    nav :questions, :url => '/questions' do
      controller :questions
    end

    nav :courses_manage, :url => '/manage/courses' do
      controller :'manage/courses'
      controller :'manage/chapters'
      controller :'manage/course_wares'
      controller :'manage/applies'
    end
  end

  # ------------------
  # 学生
  rule :student do
    nav :courses, :url => '/courses' do
      controller :courses
      controller :chapters
      controller :course_wares
    end

    nav :dashboard, :url => '/dashboard' do
      controller :index, :only => :dashboard
    end

    if R::INHOUSE
      nav :learning_plan, :url => '/plan' do
        controller :index, :only => :plan
      end
    end

    nav :user, :url => '/users/me' do
      controller :users
      controller :friends
    end

    # nav :disk, :url => '/disk' do
    #   controller :disk
    # end

    nav :tags, :url => '/tags' do
      controller :tags
    end

    nav :questions, :url => '/questions' do
      controller :questions
    end

    if R::INHOUSE
      nav :surveys, :url => '/surveys' do
        controller :surveys
      end
    end
  end

  # ------------------------

  rule :account do
    nav :edit, :url => '/account/edit' do
      controller :account, :only => :edit
    end
    
    nav :avatar, :url => '/account/avatar' do
      controller :account, :only => :avatar
    end

    nav :userpage, :url => '/account/userpage' do
      controller :account, :only => :userpage
    end

    if R::INTERNET
      nav :sync, :url => '/account/sync' do
        controller :oauth, :only => :sync
      end
    end
  end

  rule :admin_account do
    nav :password, :url => '/account/edit' do
      controller :account, :only => :edit
    end
  end

  if R::INTERNET
    rule :help do
      nav :user_opinion, :url => '/help/user_opinions/new' do
        controller :'help/user_opinions'
      end

      nav :site_changes, :url => '/help/site_changes' do
        controller :'help/site_changes'
      end
    end
  end

end
