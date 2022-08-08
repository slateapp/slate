# frozen_string_literal: true

# TwilioInfo model
class TwilioInfo < ActiveRecord::Base
  validates :phone_number, presence: true
  belongs_to :teacher
end
