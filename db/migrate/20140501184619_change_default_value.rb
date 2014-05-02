class ChangeDefaultValue < ActiveRecord::Migration
  def change
  	change_column :requests, :solved, :boolean, :default => false
  end
end
