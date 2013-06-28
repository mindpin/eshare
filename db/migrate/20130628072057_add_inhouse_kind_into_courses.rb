class AddInhouseKindIntoCourses < ActiveRecord::Migration
  def change
    add_column :courses, :inhouse_kind, :string
  end
end
