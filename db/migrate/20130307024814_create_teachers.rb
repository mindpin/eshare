class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string   :real_name,       :default => "",    :null => false
      t.string   :tid
      t.integer  :user_id
      t.boolean  :is_removed,      :default => false
      t.text     :description
      t.string   :department
      t.string   :tel
      t.string   :gender
      t.string   :nation
      t.string   :politics_status
      t.string   :id_card_number
      t.text     :other_info
      t.timestamps
    end
  end
end
