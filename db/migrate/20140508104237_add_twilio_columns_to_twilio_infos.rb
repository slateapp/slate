class AddTwilioColumnsToTwilioInfos < ActiveRecord::Migration
  def change
    add_column :twilio_infos, :phone_number, :string
    add_column :twilio_infos, :enabled, :boolean, default: false
  end
end
