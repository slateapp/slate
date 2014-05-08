class CreateTwilioInfos < ActiveRecord::Migration
  def change
    create_table :twilio_infos do |t|

      t.timestamps
    end
  end
end
