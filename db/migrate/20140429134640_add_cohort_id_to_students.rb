class AddCohortIdToStudents < ActiveRecord::Migration
  def change
    add_reference :students, :cohort, index: true
  end
end
