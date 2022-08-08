# frozen_string_literal: true

# AddCohortColumnToTeachers migration class
class AddCohortColumnToTeachers < ActiveRecord::Migration[4.2]
  def change
    add_column :teachers, :cohort, :string
  end
end
