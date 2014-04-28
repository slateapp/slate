class AddContentToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :description, :text
    add_column :requests, :category, :string
  end
end
