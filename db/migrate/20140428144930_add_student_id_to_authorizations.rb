# frozen_string_literal: true

# AddStudentIdToAuthorizations migration class
class AddStudentIdToAuthorizations < ActiveRecord::Migration[4.2]
  def change
    add_reference :authorizations, :student, index: true
  end
end
