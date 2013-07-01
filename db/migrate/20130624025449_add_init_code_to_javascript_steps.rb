class AddInitCodeToJavascriptSteps < ActiveRecord::Migration
  def change
    add_column :javascript_steps, :init_code, :text
  end
end
