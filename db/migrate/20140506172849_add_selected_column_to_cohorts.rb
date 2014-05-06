class AddSelectedColumnToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :selected, :boolean, default: false
  end
end
