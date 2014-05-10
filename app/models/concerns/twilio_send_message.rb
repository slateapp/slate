module TwilioSendMessage
  extend ActiveSupport::Concern
  def Request.board_empty?
    unsolved_requests.count == 1 || unsolved_requests.count == 0
  end

  def Request.board_empty_for?(length_of_time)
    last_solved_request = solved_requests.last
    return true if !last_solved_request
    return true if last_solved_request && board_empty? && last_solved_request.solved_at && last_solved_request.solved_at < length_of_time.ago
    false
  end

  def sms_text_body
    "There's a new request on the board, from #{student.name} about #{category.name}."
  end

  def send_message(teacher)
    account_sid = Rails.application.secrets.twilio_sid
    auth_token = Rails.application.secrets.twilio_token
    @client = Twilio::REST::Client.new account_sid, auth_token
    sms = @client.account.sms.messages.create(
      to: teacher.phone_number,
      from: Rails.application.secrets.twilio_phone_number,
      body: sms_text_body
    )
  end

  def trigger_teacher_message
    if teachers
      teachers.each{|teacher|
        if teacher.twilio_info
          send_message(teacher) if Request.board_empty_for?(5.minutes) && Rails.env.production? && teacher.sms_enabled?
        end
      }
    end
  end
end