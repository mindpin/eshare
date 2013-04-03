class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id

  acts_as_nested_set

end
