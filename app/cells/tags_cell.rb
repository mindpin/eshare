class TagsCell < Cell::Rails
  helper :application

  def public(opts = {})
    @model = opts[:model]
    @taggable_id = @model.id
    @taggable_type = @model.class.to_s
    @tags = @model.public_tags
    @sub_path = @taggable_type.downcase.pluralize

    render
  end

  def learning(opts = {})
    @user = opts[:user]
    @tags = @user.learning_tags
    @sub_path = 'courses'
    render
  end

  def course_base(opts = {})
    render
  end
end