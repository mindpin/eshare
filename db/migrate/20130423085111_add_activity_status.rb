class AddActivityStatus < ActiveRecord::Migration
  def change
    add_column :activities, :status, :string, :default => 'PREP'
  end
end
