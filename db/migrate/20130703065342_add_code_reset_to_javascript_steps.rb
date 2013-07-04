class AddCodeResetToJavascriptSteps < ActiveRecord::Migration
  def change
    add_column :javascript_steps, :code_reset, :boolean, :default => true
  end
end
