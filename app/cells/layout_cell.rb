class LayoutCell < Cell::Rails
  helper :application

  def topnav(opts = {})
    @user = opts[:user]
    render
  end

  def topnav_admin(opts = {})
    @user = opts[:user]
    render
  end

  def searchbar(opts = {})
    @user = opts[:user]
    render
  end

  def sidebar(opts = {})
    @user = opts[:user]
    render
  end

  def account_sidebar(opts = {})
    @user = opts[:user]
    render
  end

  def help_sidebar(opts = {})
    @user = opts[:user]
    render
  end

  def admin_users_filter(opts = {})
    @query = opts[:query]
    render
  end

  def manage_courses_filter(opts = {})
    @query = opts[:query]
    render
  end
end