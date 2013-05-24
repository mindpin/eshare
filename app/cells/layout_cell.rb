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
end