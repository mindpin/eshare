class CreateUserOpinions < ActiveRecord::Migration
  def change
    create_table :user_opinions do |t|
      t.string :title
      t.text   :content
      t.string :contact
      t.string :image

      t.timestamps
    end
  end
end
