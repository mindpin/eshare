class UserCell < Cell::Rails
  helper :application

  def page_navbar(opts = {})
    @user = opts[:user]
    render
  end
end