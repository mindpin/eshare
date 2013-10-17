# -*- coding: utf-8 -*-
class CreateKnowledgeQuestionPostsAndKnowledgeQuestionPostComments < ActiveRecord::Migration
  def change
    create_table :knowledge_question_posts do |t|
      t.integer :knowledge_question_id
      t.integer :creator_id
      t.text :content # 纯文本
      t.string :image # 用 carrierwave 存储图片
      t.text :code  # 代码片段
      t.string :code_type # 代码片段类型: java javascript ruby 等等
      t.timestamps
    end

    create_table :knowledge_question_post_comments do |t|
      t.integer :knowledge_question_post_id
      t.integer :creator_id
      t.integer :reply_comment_id
      t.text :content # 纯文本
      t.string :image # 用 carrierwave 存储图片
      t.text :code  # 代码片段
      t.string :code_type # 代码片段类型: java javascript ruby 等等
      t.timestamps
    end
  end
end
