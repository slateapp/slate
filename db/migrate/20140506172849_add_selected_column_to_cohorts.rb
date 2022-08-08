# frozen_string_literal: true

# AddSelectedColumnToCohorts migration class
class AddSelectedColumnToCohorts < ActiveRecord::Migration[4.2]
  def change
    add_column :cohorts, :selected, :boolean, default: false
  end
end
