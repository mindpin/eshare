class WeiboComment
  COUNT = 2

  attr_reader :omniauth_user, :created_at, :id, :text

  def initialize(user)
    @omniauth_user = user
  end

  def get_weibo_client
    omniauth = omniauth_user.send :_get_omniauth, 'weibo'
    weibo_client = WeiboOAuth2::Client.new
    weibo_client.get_token_from_hash(
      :access_token => omniauth.token,
      :expires_at   => omniauth.expires_at
    )
    return weibo_client
  end

  def short_url(url_long)
    get_weibo_client.short_url.shorten(url_long).urls.first.url_short
  end

  def get_weibo_comments(url_short)
    get_weibo_client.short_url.comment_comments(url_short).share_comments
  end

  def get_weibo_comments(url_short, page)
    get_weibo_client.short_url.comment_comments(url_short, opt={:count => COUNT, :page => page}).share_comments
  end
end