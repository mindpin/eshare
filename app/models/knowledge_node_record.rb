class KnowledgeNodeRecord < ActiveRecord::Base
  attr_accessible :knowledge_node_id, :knowledge_net_id

  validates :knowledge_node_id, :knowledge_net_id,
            :presence => true

  validates :knowledge_node_id, :uniqueness => true
end
