# frozen_string_literal: true

# AddStudentIdToRequests migration class
class AddStudentIdToRequests < ActiveRecord::Migration[4.2]
  def change
    add_reference :requests, :student, index: true
  end
end
