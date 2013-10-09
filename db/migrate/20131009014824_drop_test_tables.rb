class DropTestTables < ActiveRecord::Migration
  def change
    drop_table :test_papers
    drop_table :test_questions
    drop_table :test_paper_items
    drop_table :test_options
  end
end
