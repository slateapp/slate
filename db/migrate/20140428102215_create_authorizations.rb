# frozen_string_literal: true

# CreateAuthorizations migration class
class CreateAuthorizations < ActiveRecord::Migration[4.2]
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
