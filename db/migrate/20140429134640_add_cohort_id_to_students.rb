# frozen_string_literal: true

# AddCohortIdToStudents migration class
class AddCohortIdToStudents < ActiveRecord::Migration[4.2]
  def change
    add_reference :students, :cohort, index: true
  end
end
