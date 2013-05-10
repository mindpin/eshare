class CoursesOfTagCell < Cell::Rails
  helper :application

  def table(opts = {})
    @tagname = opts[:tag]
    @courses = Course.by_tag(@tagname).limit(21)

    render
  end
end
