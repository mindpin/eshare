class FollowCell < Cell::Rails
  helper :application

  def no_follow(opts = {})
    @user = opts[:user]
    render
  end
end