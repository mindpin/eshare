require './script/makers/base_maker.rb'

class CategoryMaker < BaseMaker
  set_producer {|name, _| Category.create :name => name}
end
