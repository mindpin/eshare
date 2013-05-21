class TagsController < ApplicationController
  def index
  end

  def set_tags
    tagable_id   = params[:tagable_id]
    tagable_type = params[:tagable_type]
    tags         = params[:tags]

    tagable_class = tagable_type.constantize
    tagable = tagable_class.find(tagable_id)

    if !user_signed_in?
      render :text => 'access denied.', :status => 401
      return
    end

    tagable.set_tag_list tags, :user => current_user
    render :text => 'ok'
  end

  def courses
    @tagname = params[:tagname]
    @courses = Course.by_tag(@tagname).page(params[:page]).per(20)
  end
end