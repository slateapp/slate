class AddCohortColumnToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :cohort, :string
  end
end
