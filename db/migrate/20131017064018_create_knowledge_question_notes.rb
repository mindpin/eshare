class CreateKnowledgeQuestionNotes < ActiveRecord::Migration
  def change
    create_table :knowledge_question_notes do |t|
      t.integer :knowledge_question_id
      t.integer :creator_id
      t.text :content # 纯文本
      t.string :image # 用 carrierwave 存储图片
      t.text :code  # 代码片段
      t.string :code_type # 代码片段类型: java javascript ruby 等等
      
      t.timestamps
    end
  end
end
