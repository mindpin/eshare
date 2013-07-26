class AddDeletedAtIntoQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :deleted_at, :time
  end
end
