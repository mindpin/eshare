class RemoveTeamTables < ActiveRecord::Migration
  def change
    drop_table :team_memberships
    drop_table :teams
  end
end
