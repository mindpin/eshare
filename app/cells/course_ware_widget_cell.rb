class CourseWareWidgetCell < Cell::Rails
  helper :application

  def video(opts = {})
    @course_ware = opts[:course_ware]
    @user = opts[:user]
    render
  end

  def pages(opts = {})
    @course_ware = opts[:course_ware]
    @user = opts[:user]
    render
  end

  def read(opts = {})
    @course_ware = opts[:course_ware]
    @user = opts[:user]

    @read_count = @course_ware.read_count_of(@user)
    @total_count = @course_ware.total_count
  end
end