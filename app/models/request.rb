class StudentCannotSolve < Exception
end

class Request < ActiveRecord::Base
	belongs_to :student
  validates :category, :description, :presence => true
  scope :todays_solved_requests, -> { where(solved: true, solved_at: Time.now.beginning_of_day..Time.now) }
  
  def category_name
    Category.find(self.category.to_i).name
  end

  def solve!
  	self.solved = true
    self.solved_at = Time.now
  	save
  end

  def update_or_solve(attributes, user)
  	if attributes[:solve]
  		raise StudentCannotSolve if user.is_a? Student
  		solve!
  	else
  		update_attributes(attributes)
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
end
