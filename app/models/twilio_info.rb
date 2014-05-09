class TwilioInfo < ActiveRecord::Base
	validates :phone_number, :presence => true
	belongs_to :teacher
end
