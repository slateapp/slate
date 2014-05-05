class AddCategoryIdToRequests < ActiveRecord::Migration
  def change
    add_reference :requests, :category, index: true
  end
end
