# frozen_string_literal: true

# AddSolvedToRequests migration class
class AddSolvedToRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :requests, :solved, :boolean
  end
end
