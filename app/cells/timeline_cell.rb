class TimelineCell < Cell::Rails
  helper :application

  def public(opts = {})
    @feeds = Feed.page(1).per(30)
    render
  end

  def home_timeline(opts = {})
    @user = opts[:user]
    @feeds = @user.home_timeline(:page => 1, :count => 30)
    render :view => :public
  end

  def user_timeline(opts = {})
    @user = opts[:user]
    @feeds = @user.user_timeline(:page => 1, :count => 30)
    render :view => :public
  end
end