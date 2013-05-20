class FollowCell < Cell::Rails
  helper :application

  def recommend(opts = {})
    @user = opts[:user]
    render
  end
end