class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string   "real_name",                      :default => "",    :null => false
      t.string   "sid"
      t.integer  "user_id"
      t.boolean  "is_removed",                     :default => false
      t.string   "faculty"
      t.string   "major"
      t.string   "gender"
      t.string   "grade"
      t.string   "kind"
      t.datetime "entry_date"
      t.integer  "graduation_year"
      t.string   "option_course"
      t.string   "exam_id"
      t.boolean  "has_graduated"
      t.boolean  "has_left"
      t.string   "nation"
      t.string   "politics_status"
      t.text     "description"
      t.string   "native_home"
      t.string   "home_address"
      t.string   "source_place"
      t.datetime "birthday"
      t.string   "tel"
      t.string   "zip_code"
      t.string   "id_card_number"
      t.string   "edu_level"
      t.string   "exception_info"
      t.text     "exception_desc"
      t.string   "graduated_school"
      t.datetime "graduated_date"
      t.string   "contact_person"
      t.string   "contact_tel"
      t.text     "other_info"
      t.boolean  "is_graduated",                   :default => false
      t.integer  "jiu_ye_xie_yi_file_entity_id"
      t.integer  "bi_ye_jian_ding_file_entity_id"
      t.timestamps
    end
  end
end
