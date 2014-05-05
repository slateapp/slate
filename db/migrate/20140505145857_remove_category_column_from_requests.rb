class RemoveCategoryColumnFromRequests < ActiveRecord::Migration
  def change
    remove_column :requests, :category, :string
  end
end
