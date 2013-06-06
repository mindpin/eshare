class WeiboComment

  attr_reader :created_at, :id, :text, :weibo_user

  def initialize(comment)
    @created_at = comment['created_at']
    @id = comment['id']
    @text = comment['text']
    @weibo_user = WeiboUser.new(comment['user'])
  end



  class WeiboUser
    attr_reader :id, :name, :weibo_homepage

    def initialize(user_hash)
      @id   = user_hash['id']
      @name = user_hash['name']   
      @weibo_homepage = "http://weibo.com/u/#{ user_hash['id'] }"
    end
  end
end