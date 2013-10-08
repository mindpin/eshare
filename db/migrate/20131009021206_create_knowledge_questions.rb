# -*- coding: utf-8 -*-
class CreateKnowledgeQuestions < ActiveRecord::Migration
  def change
    create_table :knowledge_questions do |t|
      t.string :knowledge_node_id
      t.string :kind # BOOLEAN | SINGLE_CHOOSE | MUTI_CHOOSE | CODE

      t.string :title
      t.text   :desc
      t.text   :rule
      t.text   :init_code
      t.string :code_type # JAVASCRIPT
      t.text   :choices # 选择题选项 json 格式
      t.string :answer # "ABC" | "A" | "true" | "false"
      t.timestamps
    end
  end
end
