# frozen_string_literal: true

# AddTeacherIdToRequests migration class
class AddTeacherIdToRequests < ActiveRecord::Migration[4.2]
  def change
    add_reference :requests, :teacher, index: true
  end
end
