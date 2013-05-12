class TagsCell < Cell::Rails
  def public(opts = {})
    @model = opts[:model]
    @taggable_id = @model.id
    @taggable_type = @model.class.to_s
    @tags = @model.public_tags
    @sub_path = @taggable_type.downcase.pluralize

    render
  end
end