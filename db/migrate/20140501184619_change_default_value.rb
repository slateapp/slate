# frozen_string_literal: true

# ChangeDefaultValue migration class
class ChangeDefaultValue < ActiveRecord::Migration[4.2]
  def change
    change_column :requests, :solved, :boolean, default: false
  end
end
