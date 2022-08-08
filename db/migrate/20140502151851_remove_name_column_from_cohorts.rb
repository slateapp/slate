# frozen_string_literal: true

# RemoveNameColumnFromCohorts migration class
class RemoveNameColumnFromCohorts < ActiveRecord::Migration[4.2]
  def change
    remove_column :cohorts, :name, :string
  end
end
