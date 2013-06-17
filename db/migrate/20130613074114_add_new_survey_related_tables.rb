class AddNewSurveyRelatedTables < ActiveRecord::Migration
  def self.up

    create_table :surveys do |t|
      t.string  :title
      t.integer :survey_template_id
      t.integer :creator_id
      t.timestamps
    end

    create_table :survey_results do |t|
      t.integer :survey_id
      t.integer :user_id
      t.timestamps
    end

    create_table :survey_result_items do |t|
      t.string  :kind # SINGLE_CHOICE | MULTIPLE_CHOICE | FILL | TEXT
      t.integer :survey_result_id
      t.integer :item_number # 题目序号 从  1 开始
      t.integer :answer_choice_mask # 选择题
      t.string  :answer_fill # 填空题
      t.string  :answer_text # 问答题
    end

  end

  def self.down
    drop_table :surveys
    drop_table :survey_results
    drop_table :survey_result_items
  end
end
