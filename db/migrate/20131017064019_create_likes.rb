# -*- coding: utf-8 -*-
class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :model_id # 多态关联 knowledge_question_posts 和 knowledge_question_post_comments
      t.string  :model_type #
      t.integer :user_id
      t.timestamps
    end

    add_column :knowledge_question_posts, :likes_count, :integer, :default => 0
    add_column :knowledge_question_post_comments, :likes_count, :integer, :default => 0
  end
end
