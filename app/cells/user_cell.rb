class UserCell < Cell::Rails
  helper :application

  def page_navbar(opts = {})
    @user = opts[:user]
    @cur_user = opts[:cur_user]
    render
  end
end