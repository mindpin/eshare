class CoursesController < ApplicationController
  before_filter :authenticate_user!, 
                :except => [:show, :questions, :users_rank]
  before_filter :pre_load
  
  layout Proc.new { |controller|
    case controller.action_name
    when 'show', 'users_rank', 'questions', 'notes'
      return 'course_show'
    when 'index', 'sch_select'
      return 'grid'
    else
      return 'application'
    end
  }

  def pre_load
    @course = Course.find(params[:id]) if params[:id]
  end

  def index
  end

  def sch_select
    @courses = Course.page(params[:page]).per(18)
  end

  def show
  end

  def manage
    @courses = current_user.courses.page(params[:page])
  end

  def manage_one
  end

  # 签到
  def checkin
    @course.sign current_user
    render :json => {
      :streak => @course.current_streak_for(current_user),
      :order => @course.today_sign_order_of(current_user)
    }
  end

  # 用户排名
  def users_rank
    @rank = @course.users_rank
  end

  # 学生选课 INHOUSE
  def student_select
    if params[:cancel]
      current_user.cancel_select_course @course
      
      case params[:page]
      when 'sch_select'
        render :json => { 
          :status => 'request',
          :html => ( render_cell :course, :sch_select_table, 
                                 :user => current_user, 
                                 :courses => [@course] )
        }
      else
        render :json => { :status => 'cancel' }
      end

      return
    end

    current_user.select_course @course

    case params[:page]
    when 'sch_select'
      render :json => { 
        :status => 'request',
        :html => ( render_cell :course, :sch_select_table, 
                               :user => current_user, 
                               :courses => [@course] )
      }
    else
      render :json => { :status => 'request' }
    end
  end

  def questions
    @questions = @course.questions.page params[:page]
  end

  def notes
    @notes = @course.notes.page params[:page]
  end
end