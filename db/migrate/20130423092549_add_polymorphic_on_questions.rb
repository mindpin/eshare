class AddPolymorphicOnQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :model_id, :integer
    add_column :questions, :model_type, :string
  end
end
