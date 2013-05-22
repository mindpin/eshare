class AddInfoJsonToOnmiauths < ActiveRecord::Migration
  def change
    add_column :omniauths, :info_json, :text
  end
end
