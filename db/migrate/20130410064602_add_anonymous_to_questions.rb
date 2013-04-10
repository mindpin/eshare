class AddAnonymousToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :is_anonymous, :boolean, :default => false
  end
end
