# -*- coding: utf-8 -*-
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

    nav :dashboard, :name => '课程首页', :url => '/dashboard' do
      controller :index, :only => :dashboard
    end

    nav :media_resources, :name => '资源网盘', :url => '/file' do
      nav :my_resources, :name => '我的文件夹', :url => '/file' do
        controller :media_resources
      end

      nav :media_shares, :name => '收到的共享', :url => '/media_shares' do
        controller :media_shares
      end

      nav :public_resources, :name => '公共资源库', :url => '/public_resources' do
        controller :public_resources
      end
    end

    nav :homeworks, :name => '作业', :url => '/homeworks' do
      controller :homeworks
    end

    nav :questions, :name => '问答', :url => '/questions' do
      controller :questions
    end

    nav :course_surveys, :name => '课程调查', :url => '/course_surveys' do
      controller :course_surveys
    end

    nav :announcements, :name => '系统通知', :url => '/announcements' do
      controller :announcements
    end

    nav :comments, :name => '收到的评论', :url => '/comments/received' do
      controller :comments
    end

  end

  # ------------------
  # 学生
  rule :student do

    nav :dashboard, :name => '课程首页', :url => '/dashboard' do
      controller :index, :only => :dashboard
    end

    nav :media_resources, :name => '资源网盘', :url => '/file' do
      nav :my_resources, :name => '我的文件夹', :url => '/file' do
        controller :media_resources
      end

      nav :media_shares, :name => '收到的共享', :url => '/media_shares' do
        controller :media_shares
      end

      nav :public_resources, :name => '公共资源库', :url => '/public_resources' do
        controller :public_resources
      end
    end

    nav :homeworks, :name => '作业', :url => '/homeworks' do
      controller :homeworks
    end

    nav :questions, :name => '问答', :url => '/questions' do
      controller :questions
    end

    nav :course_surveys, :name => '课程调查', :url => '/course_surveys' do
      controller :course_surveys
    end

    nav :announcements, :name => '系统通知', :url => '/announcements' do
      controller :announcements
    end

    nav :comments, :name => '收到的评论', :url => '/comments/received' do
      controller :comments
    end

  end
end
