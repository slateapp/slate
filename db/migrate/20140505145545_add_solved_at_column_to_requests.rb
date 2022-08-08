# frozen_string_literal: true

# AddSolvedAtColumnToRequests migration class
class AddSolvedAtColumnToRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :requests, :solved_at, :datetime
  end
end
