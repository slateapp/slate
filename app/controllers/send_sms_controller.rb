class SendSmsController < ApplicationController

	def index
	end

	def send_sms
		number_to_send_to = params[:number_to_send_to]

		twilio_sid = "AC441c582d96e200544d66d83954953feb"
		twilio_token = "523ca7f1e7222606b0ef63405561a8ee"
		twilio_phone_number = "+441784603115"

		@twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

		@twilio_client.account.sms.messages.create(
			:from => "+1#{twilio_phone_number}",
			:to => number_to_send_to,
			:body => "This is a test message."
		)
	end
end
