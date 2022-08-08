# frozen_string_literal: true

# AddContentToRequests migration class
class AddContentToRequests < ActiveRecord::Migration[4.2]
  def change
    add_column :requests, :description, :text
    add_column :requests, :category, :string
  end
end
