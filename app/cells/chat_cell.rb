class ChatCell < Cell::Rails
  helper :application

  def chatbar(opts = {})
    @user = opts[:user]
    render
  end
end