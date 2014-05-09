require 'twilio-ruby'

class StudentCannotSolve < Exception
end

class Request < ActiveRecord::Base
  belongs_to :student
  belongs_to :category
	belongs_to :teacher
  validates :category, :description, :presence => true
  validate :time_creation
  scope :todays_requests, ->(minute) { where(created_at: Time.now.beginning_of_day..minute) }
  scope :created_requests_count_for, ->(minute) { where(created_at: minute-1..minute).count }
  scope :solved_requests_count_for, ->(minute) { where(solved_at: minute-1..minute).count }
  scope :this_weeks_requests, -> {where(created_at: Date.today.beginning_of_week..Time.now)}
  scope :solved_by, ->(teacher) {where(teacher: teacher)}
  scope :categorised_by, ->(category) {where(category: category)}
  scope :for_cohort, ->(cohort) {where(student:Student.where(cohort: cohort))}
  scope :solved_requests, -> { where(solved: true) }
  scope :unsolved_requests, -> { where(solved: false) }
  after_save :trigger_teacher_message

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

  ## Statistics

  def time_to_solve
    solved_at - created_at
  end

  def self.get_cohort(cohort)
    cohort ? Cohort.find(cohort) : Cohort.all
  end

  def self.total_wait_time(cohort)
    todays_requests(Time.now).solved_requests.for_cohort(cohort).inject(0){|sum, request|
      sum + request.time_to_solve
    }
  end

  def self.todays_average_wait_time_for(cohort)
    cohort = get_cohort(cohort)
    return 0 if todays_requests(Time.now).solved_requests.for_cohort(cohort).count == 0
    (total_wait_time(cohort)/self.todays_requests(Time.now).solved_requests.for_cohort(cohort).count)/60
  end

  def self.first_request_time(cohort)
    (todays_requests(Time.now).for_cohort(cohort).first.created_at - 1).to_i
  end

  def self.queue_lengths_for(cohort)
    (first_request_time(cohort)..DateTime.now.to_i).step(1.minute).map{|minute|
      minute = Time.at(minute).to_datetime
      created_requests_count_for(minute) - solved_requests_count_for(minute)
    }.compact
  end

  def self.todays_average_queue_for(cohort)
    cohort = get_cohort(cohort)
    return 0 if todays_requests(Time.now).for_cohort(cohort).count == 0
    return 0 if queue_lengths_for(cohort).count == 0
    queue_lengths_for(cohort).inject{|sum,length| sum + length}/queue_lengths_for(cohort).count
  end

  def self.weekly_request_categories_for(cohort)
    cohort = get_cohort(cohort)
    this_weeks_requests.for_cohort(cohort).map{|request|
      [request.category.name, Request.this_weeks_requests.categorised_by(request.category).count]
    }.uniq.compact
  end

  def self.leaderboard_for(cohort)
    cohort = get_cohort(cohort)
    this_weeks_requests.for_cohort(cohort).map{|request|
      [request.teacher.name, Request.this_weeks_requests.solved_by(request.teacher).count] if request.solved
    }.uniq.compact
  end

  def self.weekly_issues_average_over_day_for(cohort)
    cohort = get_cohort(cohort)
    [{name: "Average Time to Solve", data: this_weeks_requests.for_cohort(cohort).solved_requests.group_by_hour(:solved_at).count},
    {name: "Average Queue", data: this_weeks_requests.for_cohort(cohort).group_by_hour(:created_at).count}]
  end

  ## Twilio

  def self.board_empty?
    unsolved_requests.none?
  end

  def self.board_empty_for?(length_of_time)
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

  def teacher
    Teacher.by_cohort(student.cohort.id.to_s)
  end
end
