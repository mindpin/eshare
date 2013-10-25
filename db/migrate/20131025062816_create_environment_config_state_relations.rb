class CreateEnvironmentConfigStateRelations < ActiveRecord::Migration
  def change
    create_table :environment_config_state_relations do |t|
      t.integer :parent_state_id # 前置 state
      t.integer :child_state_id # 后续 state
    end
  end
end
