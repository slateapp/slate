# frozen_string_literal: true

# AddTwilioInfoIdToTeachers migration class
class AddTwilioInfoIdToTeachers < ActiveRecord::Migration[4.2]
  def change
    add_reference :twilio_infos, :teacher, index: true
  end
end
