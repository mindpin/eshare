class CreateMists < ActiveRecord::Migration
  def change

    create_table :mists do |t|
      t.text :desc
      t.text :kind
      t.integer :file_entity_id # 文本片段的内容保存到一个 file_entity 中

      t.timestamps
    end

  end
end
