class AddSolvedAtColumnToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :solved_at, :datetime
  end
end
