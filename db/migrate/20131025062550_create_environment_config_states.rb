class CreateEnvironmentConfigStates < ActiveRecord::Migration
  def change
    create_table :environment_config_states do |t|
      t.string :title
      t.text :content
      t.integer :course_ware_id
      
      t.timestamps
    end

  end
end
