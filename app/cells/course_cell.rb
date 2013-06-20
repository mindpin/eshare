class CourseCell < Cell::Rails
  helper :application

  def card(opts = {})
    @course = opts[:course]
    @user = opts[:user]

    @chapters_count = @course.chapters.count
    @questions_count = @course.questions_count
    @percent = @course.read_percent(@user)

    render
  end

  def smallcard(opts = {})
    @course = opts[:course]
    @user = opts[:user]

    @percent = @course.read_percent(@user)

    render
  end

  def minicard(opts = {})
    @course = opts[:course]
    @user = opts[:user]

    @percent = @course.read_percent(@user)

    render
  end

  def recent_learning(opts = {})
    @user = opts[:user]
    @courses = @user.learning_courses.limit(5)
    render
  end

  def advise(opts = {})
    @user = opts[:user]
    @courses = @user.advise_courses
    render
  end

  def checkin(opts = {})
    @course = opts[:course]
    @user = opts[:user]
    render
  end

  def student_select(opts = {})
    @course = opts[:course]
    @user = opts[:user]
    render
  end

  def sidebar(opts = {})
    @course = opts[:course]
    @user = opts[:user]
    render
  end

  def header(opts = {})
    @course = opts[:course]
    render
  end

  def show_chapters(opts = {})
    @course = opts[:course]
    @user = opts[:user]
    render
  end

  def learning_users(opts = {})
    @course = opts[:course]
    render
  end

  def learning_chart(opts = {})
    @course = opts[:course]
    @user = opts[:user]
    render
  end

  def navbar(opts = {})
    @course = opts[:course]
    render
  end

  def user_attitudes_form(opts = {})
    @course = opts[:course]
    @user = opts[:user]
    render
  end
end