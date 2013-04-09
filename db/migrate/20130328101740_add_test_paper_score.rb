class AddTestPaperScore < ActiveRecord::Migration
  def up
    add_column :test_papers, :score, :integer
  end
end
