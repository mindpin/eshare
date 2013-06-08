class AddedUidToOmniauth < ActiveRecord::Migration
  def change
    add_column :omniauths, :uid, :string
  end
end
