class TimelineCell < Cell::Rails
  helper :application

  def public(opts = {})
    @feeds = Feed.page(1).per(30)
    render
  end
end