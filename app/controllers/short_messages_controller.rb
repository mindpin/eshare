class ShortMessagesController < ApplicationController
  before_filter :authenticate_user!

  def create
    contact_user = User.find params[:contact_user_id]
    content = params[:content]

    message = current_user.send_message(content, contact_user)

    render :json => message
  end

  def chatlog
    contact_user = User.find params[:contact_user_id]
    @messages = current_user.short_messages_of_user(contact_user).order('id DESC').limit(5).reverse

    render :layout => false
  end
end