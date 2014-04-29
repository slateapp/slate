class AddStudentIdToRequests < ActiveRecord::Migration
  def change
    add_reference :requests, :student, index: true
  end
end
