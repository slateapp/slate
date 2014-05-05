class AddTeacherIdToRequests < ActiveRecord::Migration
  def change
    add_reference :requests, :teacher, index: true
  end
end
