class ManageCoursesBreadcrumbCell < Cell::Rails
  def display(opts = {})
    @model = opts[:model]
    render
  end

  def form(opts = {})
    @model = opts[:model]
    render
  end
end