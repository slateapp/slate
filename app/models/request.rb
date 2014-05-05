class StudentCannotSolve < Exception
end

class Request < ActiveRecord::Base
  belongs_to :student
  belongs_to :category
	belongs_to :teacher
  validates :category, :description, :presence => true
  scope :todays_solved_requests, -> { where(solved: true, solved_at: Time.now.beginning_of_day..Time.now) }
  scope :todays_requests, ->(minute) { where(created_at: Time.now.beginning_of_day..minute) }

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
      request_array = todays_requests(minute).map{ |request| request.category if !request.solved || request.solved_at > minute }.compact
      queue_lengths << request_array.count unless request_array.empty?
      minute += 60
    end
    return 0 if queue_lengths.count == 0
    queue_lengths.inject{|sum,length| sum + length}/queue_lengths.count
  end
end
