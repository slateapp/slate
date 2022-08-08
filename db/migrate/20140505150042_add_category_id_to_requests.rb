# frozen_string_literal: true

# AddCategoryIdToRequests migration class
class AddCategoryIdToRequests < ActiveRecord::Migration[4.2]
  def change
    add_reference :requests, :category, index: true
  end
end
