# frozen_string_literal: true

# AddApprovedColumnToStudents migration class
class AddApprovedColumnToStudents < ActiveRecord::Migration[4.2]
  def change
    add_column :students, :approved, :boolean, default: false
  end
end
