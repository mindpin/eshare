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
end