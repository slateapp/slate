# frozen_string_literal: true

# CreateStudents migration class
class CreateStudents < ActiveRecord::Migration[4.2]
  def change
    create_table :students do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
