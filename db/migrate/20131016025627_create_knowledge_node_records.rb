class CreateKnowledgeNodeRecords < ActiveRecord::Migration
  def change
    create_table :knowledge_node_records do |t|
      t.string :knowledge_node_id
      t.string :knowledge_net_id
      t.timestamps
    end
  end
end
