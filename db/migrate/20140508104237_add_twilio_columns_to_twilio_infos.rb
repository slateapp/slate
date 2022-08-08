# frozen_string_literal: true

# AddTwilioColumnsToTwilioInfos migration class
class AddTwilioColumnsToTwilioInfos < ActiveRecord::Migration[4.2]
  def change
    add_column :twilio_infos, :phone_number, :string
    add_column :twilio_infos, :enabled, :boolean, default: false
  end
end
