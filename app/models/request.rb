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

  def self.board_empty?
    where(solved: false).none?
  end

  # - No requests = true (ultimately sends an sms but don't test yet) (complete)
  # - Request (unsolved) = false (complete)
  # - Request (solved) = true (complete)
  # - Mix of solved and unsolved = false (complete)

  # create callback to send sms when some of these conditions are true

  def self.board_empty_for?(length_of_time)
    return true if count.zero?
    self.last.solved_at.to_i - self.create.created_at.to_i >= length_of_time
  end

  def save_or_send_message
    send_message if Request.board_empty_for?(5)
    save
  end

end

    # last_request_solved_at = Request.last.solved_at.to_i
    # new_request_created_at = Request.create.created_at.to_i

    # length_of_time.to_i >= last_request_solved_at - new_request_created_at
    # # send_sms if self.board_empty? && length_of_time => 5.minutes : do_nothing