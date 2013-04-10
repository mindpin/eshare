class AddAnonymousToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :is_anonymous, :boolean, :default => false
  end
end
