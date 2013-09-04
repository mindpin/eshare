class CourseWareCell < Cell::Rails
  helper :application

  def widget(opts = {})
    @course_ware = opts[:course_ware]
    @user = opts[:user]
    render
  end

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

  # javascript
  def javascript(opts = {})
    @course_ware = opts[:course_ware]
    @user = opts[:user]
    render
  end

  def javascript_steps_form(opts = {})
    @course_ware = opts[:course_ware]
    @current_step = opts[:current_step]
    @chapter = @course_ware.chapter
    
    render
  end

  def manage_table(opts = {})
    @course_wares = opts[:course_wares]
    render
  end

  def manage_chapter_table(opts = {})
    @chapters = opts[:chapters]
    render
  end

  # markdown
  def markdown(opts = {})
    @course_ware = opts[:course_ware]
    @user = opts[:user]
    render
  end
end