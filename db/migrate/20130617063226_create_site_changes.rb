class CreateSiteChanges < ActiveRecord::Migration
  def change
    create_table :site_changes do |t|
      t.text   :content

      t.timestamps
    end
  end
end
