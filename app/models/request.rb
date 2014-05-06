class StudentCannotSolve < Exception
end

class Request < ActiveRecord::Base
  belongs_to :student
  belongs_to :category
	belongs_to :teacher
  validates :category, :description, :presence => true
  scope :todays_solved_requests, -> { where(solved: true, solved_at: Time.now.beginning_of_day..Time.now) }
  
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

  def self.blank_board?
    true
  end

  # - No requests = true (ultimately sends an sms but don't test yet)
  # - Request (unsolved) = false
  # - Request (solved) = true
  # - Mix of solved and unsolved = false

  # create callback to send sms when some of these conditions are true

  def self.board_empty_for?(length_of_time)
    true
  end

  # - No requests = true
  # - 
end
