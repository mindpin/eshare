class AddTitleAndHintToJavascriptSteps < ActiveRecord::Migration
  def change
    add_column :javascript_steps, :title, :string
    add_column :javascript_steps, :desc, :text
    add_column :javascript_steps, :hint, :text
  end
end
