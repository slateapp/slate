require 'twilio-ruby'
# require 'yml'

class StudentCannotSolve < Exception
end

class Request < ActiveRecord::Base
  belongs_to :student
  belongs_to :category
	belongs_to :teacher
  validates :category, :description, :presence => true
  scope :todays_solved_requests, -> { where(solved: true, solved_at: Time.now.beginning_of_day..Time.now) }
  before_create :trigger_teacher_message
  
  # def category_name
  #   Category.find(self.category.to_i).name
  # end

  def solve!(teacher)
  	self.solved = true
    self.solved_at = Time.now
    self.teacher = teacher
  	save
  end

  def update_or_solve(attributes, user)
    if attributes[:solved]
      raise StudentCannotSolve if user.is_a? Student
      solve!(attributes[:teacher])
    else
      update_attributes(attributes)
      save
  	end
  end

  def time_to_solve
    solved_at - created_at
  end

  def self.todays_average_wait_time
    return 0 if todays_solved_requests.count == 0
    total_wait_time = self.todays_solved_requests.inject(0){|sum, request| sum + request.time_to_solve}
    (total_wait_time/self.todays_solved_requests.count)/60
  end

  def self.todays_average_queue
    queue_lengths = []
    minute = Time.now.beginning_of_day
    while minute < Time.now
      requests = self.where(created_at: Time.now.beginning_of_day..minute)
      request_array = []
      requests.each{ |request| request_array << request.category if request.category && (!request.solved || request.solved_at > minute) }
      queue_lengths << request_array.count unless request_array.empty?
      minute += 60
    end
    return 0 if queue_lengths.count == 0
    queue_lengths.inject{|sum,length| sum + length}/queue_lengths.count
  end

  def self.board_empty?
    where(solved: false).none?
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
    "Teacher you have a new request"
  end

  def send_message
    account_sid = Rails.application.secrets.TWILIO_TEST_SID
    auth_token = Rails.application.secrets.TWILIO_TEST_TOKEN
    
    @client = Twilio::REST::Client.new account_sid, auth_token

    sms = @client.account.sms.messages.create(
      :to => Rails.application.secrets.TWILIO_TEST_NUMBER,
      :from => Rails.application.secrets.TWILIO_PHONE_NUMBER,
      :body => sms_text_body
    )
  end

  def trigger_teacher_message
    send_message if Request.board_empty_for?(5.minutes)
  end
end
