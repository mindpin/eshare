class SyncCell < Cell::Rails
  helper :application

  def weibo(opts = {})
    @user = opts[:user]
    @cur_user = opts[:cur_user]
    render
  end
end