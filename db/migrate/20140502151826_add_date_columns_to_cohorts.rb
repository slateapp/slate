class AddDateColumnsToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :month, :string
    add_column :cohorts, :year, :string
  end
end
