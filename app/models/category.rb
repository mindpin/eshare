class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id

  validates :name, :presence => true

  acts_as_nested_set

  def self.get_nodes(file)
    YAML::load(File.open(file.path))
  end

  def self.save_yaml(file)
    nodes = get_nodes(file)
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
