class RemoveSolvedFromRequests < ActiveRecord::Migration
  def change
  	remove_column :requests, :solved
  end
end
