class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string    :title
      t.text      :content
      t.integer   :creator_id
      t.datetime  :start_time # 开始时间
      t.datetime  :end_time # 结束时间
      
      t.timestamps
    end
  end
end
