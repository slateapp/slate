require 'twilio-ruby'

class StudentCannotSolve < Exception
end

class Request < ActiveRecord::Base
  include Statistics
  include TwilioSendMessage
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

  def teacher
    Teacher.by_cohort(student.cohort.id.to_s)
  end
end
