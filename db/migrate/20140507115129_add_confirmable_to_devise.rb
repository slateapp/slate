class AddConfirmableToDevise < ActiveRecord::Migration
  def change
    add_column :teachers, :confirmation_token, :string
    add_column :teachers, :confirmed_at, :datetime
    add_column :teachers, :confirmation_sent_at, :datetime
    add_index :teachers, :confirmation_token, :unique => true
  end
end
