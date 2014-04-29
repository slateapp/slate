class AddStudentIdToAuthorizations < ActiveRecord::Migration
  def change
    add_reference :authorizations, :student, index: true
  end
end
