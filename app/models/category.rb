class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id

  acts_as_nested_set

  def self.save_yaml(file)
    nodes = YAML::load(File.open(file))
    save_nodes(nodes, nil)
  end

  def self.save_nodes(nodes, parent)
    nodes.keys.each do |name|
      current = self.create(:name => name)
      current.move_to_child_of(parent) if parent.present?
            
      save_nodes(nodes[name], current) if nodes[name].kind_of? Hash
    end
  end

end
