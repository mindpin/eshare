class CreateCssSteps < ActiveRecord::Migration
  def change

    create_table :css_steps do |t|
      t.integer :course_ware_id
      t.text    :content
      t.text    :rule

      t.timestamps
    end

  end
end
