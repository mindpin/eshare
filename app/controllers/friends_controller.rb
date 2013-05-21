class FriendsController < ApplicationController
  layout 'user_page', :only => [:followings, :followers]

  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(1)
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(1)
  end

  def follow
    user = User.find(params[:user_id])
    if user != current_user
      current_user.follow user
      render :text => 'ok'
      return
    end

    render :text => '不能关注自己', :status => 500
  end

  def unfollow
    user = User.find(params[:user_id])
    current_user.unfollow user
    render :text => 'ok'
  end
end