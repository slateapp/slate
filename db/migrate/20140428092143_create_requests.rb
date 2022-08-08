# frozen_string_literal: true

# CreateRequest migration class
class CreateRequests < ActiveRecord::Migration[4.2]
  def change
    create_table :requests do |t|
      t.timestamps
    end
  end
end
