class SyncCell < Cell::Rails
  helper :application

  def weibo(opts = {})
    @user = opts[:user]
    render
  end
end