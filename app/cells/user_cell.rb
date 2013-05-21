class UserCell < Cell::Rails
  helper :application

  def stat(opts = {})
    @user = opts[:user]
    render
  end
end