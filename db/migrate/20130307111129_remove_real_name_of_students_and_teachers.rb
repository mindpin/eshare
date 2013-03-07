class RemoveRealNameOfStudentsAndTeachers < ActiveRecord::Migration
  def change
    remove_column :students, :real_name
    remove_column :teachers, :real_name
  end
end
