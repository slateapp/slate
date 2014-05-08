class AddTwilioInfoIdToTeachers < ActiveRecord::Migration
  def change
    add_reference :twilio_infos, :teacher, index: true
  end
end
