class AddStatusToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :status, :string, :default => "PUBLISHED" 
  end
end
