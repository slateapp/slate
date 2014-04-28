class AddContentToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :content, :text
  end
end
