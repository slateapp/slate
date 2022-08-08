# frozen_string_literal: true

# CreateTwilioInfos migration class
class CreateTwilioInfos < ActiveRecord::Migration[4.2]
  def change
    create_table :twilio_infos do |t|
      t.timestamps
    end
  end
end
