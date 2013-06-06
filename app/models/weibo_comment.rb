class WeiboComment

  attr_reader :created_at, :id, :text

  def initialize(comment)
    @created_at = comment['created_at']
    @id = comment['id']
    @text = comment['text']
  end
end