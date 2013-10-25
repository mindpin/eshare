class AddTimeIntoEnvironmentConfigStateRelations < ActiveRecord::Migration
  def up
    add_timestamps(:environment_config_state_relations)
  end
end
