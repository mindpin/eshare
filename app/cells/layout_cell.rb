class LayoutCell < Cell::Rails
  helper :application

  def topnav(opts = {})
    @user = opts[:user]
    render
  end

  def sidebar(opts = {})
    @user = opts[:user]
    render
  end
end