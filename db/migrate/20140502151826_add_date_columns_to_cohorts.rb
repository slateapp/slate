# frozen_string_literal: true

# AddDateColumnsToCohorts migration class
class AddDateColumnsToCohorts < ActiveRecord::Migration[4.2]
  def change
    add_column :cohorts, :month, :string
    add_column :cohorts, :year, :string
  end
end
