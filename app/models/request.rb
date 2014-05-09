require 'twilio-ruby'

class StudentCannotSolve < Exception
end

class Request < ActiveRecord::Base
  include Statistics
  include TwilioSendMessage
  include RequestScopesRelationships

  def time_creation
    t = Date.today
    request_from = Time.new(t.year, t.month, t.day, 6)
    request_until = Time.new(t.year, t.month, t.day, 22)
    if Time.now > request_until || Time.now < request_from
      errors.add(:created_at, "You can only create a request between #{request_from.strftime("%H:%M")} and #{request_until.strftime("%H:%M")}, please try again later.")
    end
  end

  def solve!(teacher)
  	self.solved = true
    self.solved_at = Time.now
    self.teacher = teacher
  	save
    WebsocketRails[:request_solved].trigger 'solved', self.id
  end

  def update_or_solve(attributes, user)
    attributes[:category] = Category.find(attributes[:category]) if attributes[:category]
    if attributes[:solved]
      raise StudentCannotSolve if user.is_a? Student
      solve!(user)
    else
      update_attributes(attributes)
      save
  	end
  end

  def teacher
    Teacher.by_cohort(student.cohort.id.to_s)
  end

  def self.board_empty_for?(length_of_time)
    last_solved_request = where(solved: true).last
    return true if count.zero?

    if last_solved_request && board_empty? && last_solved_request.solved_at && last_solved_request.solved_at < length_of_time.ago
      return true
    end

    false
  end

  def sms_text_body
    "There's a new request on the board"
  end

  def send_message
    account_sid = Rails.application.secrets.twilio_sid
    auth_token = Rails.application.secrets.twilio_token
    
    @client = Twilio::REST::Client.new account_sid, auth_token

    sms = @client.account.sms.messages.create(
      :to => teacher_twilio.phone_number,
      :from => Rails.application.secrets.twilio_phone_number,
      :body => sms_text_body
    )
  end

  def trigger_teacher_message
    send_message if Request.board_empty_for?(30.seconds) && Rails.env.production? && sms_enabled?
  end

  def teacher_twilio
    cohort = student.cohort_id
    teacher_phone = Teacher.find_by(cohort: cohort.month.to_s).twilio_info # for some reason it doesn't look like twilio_info is connection to Teacher
  end

  def sms_enabled?
    teacher_twilio.enabled?
  end 
end