# frozen_string_literal: true

# CreateCohorts migration class
class CreateCohorts < ActiveRecord::Migration[4.2]
  def change
    create_table :cohorts do |t|
      t.string :name

      t.timestamps
    end
  end
end
