class CourseApplyCell < Cell::Rails
  helper :application

  def apply(opts = {})
    @user = opts[:user]
    @apply = opts[:apply]
    render
  end

  def manage_table(opts = {})
    @applies = opts[:applies]
    render
  end
end