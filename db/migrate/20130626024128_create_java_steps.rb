class CreateJavaSteps < ActiveRecord::Migration
  def change
    create_table :java_steps do |t|
      t.integer :course_ware_id
      t.string  :title     # 标题
      t.text    :desc      # 描述
      t.text    :hint      # 提示
      t.text    :content   # 题目要求
      t.text    :rule      # 验收规则
      t.text    :init_code # 初始代码
      
      t.timestamps
    end

  end
end
