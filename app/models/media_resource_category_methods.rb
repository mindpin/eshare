module MediaResourceCategoryMethods
  def self.included(base)
    base.belongs_to :category
    base.scope :publics, :conditions => "category_id is not null"
    base.scope :by_category, lambda {|category|{ :conditions => ['category_id = ?', category.id] }}
  end

  def to_public(category)
    self.category = category
    self.save
  end
end