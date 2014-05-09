module TwilioSendMessage
  extend ActiveSupport::Concern
  def Request.board_empty?
    unsolved_requests.none?
  end

  def Request.board_empty_for?(length_of_time)
    last_solved_request = solved_requests.last
    return true if count.zero?
    return true if last_solved_request && board_empty? && last_solved_request.solved_at && last_solved_request.solved_at < length_of_time.ago
    false
  end

  def sms_text_body
    "There's a new request on the board"
  end

  def send_message
    account_sid = Rails.application.secrets.TWILIO_SID
    auth_token = Rails.application.secrets.TWILIO_TOKEN
    @client = Twilio::REST::Client.new account_sid, auth_token
    sms = @client.account.sms.messages.create(
      to: teacher.phone_number,
      from: Rails.application.secrets.TWILIO_PHONE_NUMBER,
      body: sms_text_body
    )
  end

  def trigger_teacher_message
    send_message if Request.board_empty_for?(30.seconds) && Rails.env.production? && teacher.sms_enabled?
  end
end