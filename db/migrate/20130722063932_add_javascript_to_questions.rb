class AddJavascriptToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :step_id, :integer
    add_column :questions, :step_type, :string
    add_column :questions, :step_history_id, :integer
  end
end
