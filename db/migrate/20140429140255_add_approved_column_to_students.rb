class AddApprovedColumnToStudents < ActiveRecord::Migration
  def change
    add_column :students, :approved, :boolean, default: false
  end
end
