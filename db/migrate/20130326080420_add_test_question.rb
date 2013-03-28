class AddTestQuestion < ActiveRecord::Migration
  def change
    add_column :test_questions, :kind,              :string
    add_column :test_questions, :choice_options,    :text
    add_column :test_questions, :answer_fill,       :string
    add_column :test_questions, :answer_true_false, :boolean
    add_column :test_questions, :answer_choice_mask,:integer
  end
end
