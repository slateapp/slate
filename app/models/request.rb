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
  scope :todays_requests, ->(minute) { where(created_at: Time.now.beginning_of_day..minute) }
  scope :this_weeks_requests, -> {where(created_at: (Date.today.beginning_of_week)..Time.now)}
  scope :solved_by, ->(teacher) {where(teacher: teacher)}
  scope :categorised_by, ->(category) {where(category: category)}
  scope :for_cohort, ->(cohort) {where(student:Student.where(cohort: cohort))}
  scope :solved_requests, -> { where(solved: true) }
  scope :unsolved_requests, -> { where(solved: false) }
  before_create :trigger_teacher_message
  
  # def category_name
  #   Category.find(self.category.to_i).name
  # end

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

  def time_to_solve
    solved_at - created_at
  end

  def self.todays_average_wait_time_for(cohort)
    cohort = cohort ? Cohort.find(cohort) : Cohort.all
    return 0 if todays_solved_requests.for_cohort(cohort).count == 0
    total_wait_time = self.todays_solved_requests.for_cohort(cohort).inject(0){|sum, request| sum + request.time_to_solve}
    (total_wait_time/self.todays_solved_requests.for_cohort(cohort).count)/60
  end

  def self.todays_average_queue_for(cohort)
    cohort = cohort ? Cohort.find(cohort) : Cohort.all
    queue_lengths = []
    return 0 if todays_solved_requests.for_cohort(cohort).count == 0
    todays_requests(Time.now).for_cohort(cohort).group_by_minute(:created_at).count.each{|key,value| queue_lengths << value }
    queue_lengths.reject!{|queue_length| queue_length == 0}
    queue_lengths.inject{|sum,length| sum + length}/queue_lengths.count
  end

  def self.weekly_request_categories_for(cohort)
    cohort = cohort ? Cohort.find(cohort) : Cohort.all
    this_weeks_requests.for_cohort(cohort).map{|request|
      [request.category.name, Request.this_weeks_requests.categorised_by(request.category).count]
    }.uniq
  end

  def self.leaderboard_for(cohort)
    cohort = cohort ? Cohort.find(cohort) : Cohort.all
    this_weeks_requests.for_cohort(cohort).map{|request|
      [request.teacher.name, Request.this_weeks_requests.solved_by(request.teacher).count] if request.solved
    }.uniq
  end

  def self.weekly_issues_average_over_day_for(cohort)
    cohort = cohort ? Cohort.find(cohort) : Cohort.all
    [{name: "Average Time to Solve", data: this_weeks_requests.for_cohort(cohort).solved_requests.group_by_hour(:solved_at).count},
    {name: "Average Queue", data: this_weeks_requests.for_cohort(cohort).group_by_hour(:created_at).count}]
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
