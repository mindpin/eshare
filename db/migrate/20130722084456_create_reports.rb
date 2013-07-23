class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :user_id           # 举报人
      t.integer :report_user_id    # 被举报人
      t.text :desc                 # 举报描述
      t.integer :model_id          # 被举报的内容多态关联
      t.string :model_type         # 被举报的内容多态关联
      t.string :status, :default => 'UNPROCESSED'    # 被管理员确认或者驳回，取值有三个 “CONFIRM” | ‘REJECT’ | 'UNPROCESSED'
      t.text   :admin_reply        # 管理员回复
      
      t.timestamps
    end
  end
end
