# frozen_string_literal: true

# RemoveCategoryColumnFromRequests migration class
class RemoveCategoryColumnFromRequests < ActiveRecord::Migration[4.2]
  def change
    remove_column :requests, :category, :string
  end
end
