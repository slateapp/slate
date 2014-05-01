class CreateCategeories < ActiveRecord::Migration
  def change
    create_table :categeories do |t|
      t.string :name

      t.timestamps
    end
  end
end
