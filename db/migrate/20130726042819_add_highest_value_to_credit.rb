class AddHighestValueToCredit < ActiveRecord::Migration
  def change
    add_column :credits, :highest_value, :integer, :default => 0
  end
end
