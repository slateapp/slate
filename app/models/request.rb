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

  def self.weekly_request_categories
    this_weeks_requests.map{|request|
      [request.category.name, Request.this_weeks_requests.categorised_by(request.category).count]
    }.uniq
  end

  def self.leaderboard
    this_weeks_requests.map{|request|
      [request.teacher.name, Request.this_weeks_requests.solved_by(request.teacher).count] if request.solved
    }.uniq
  end

  def self.weekly_issues_average_over_day_for(cohort)
    cohort = cohort ? Cohort.find(cohort) : Cohort.all
    [{name: "Average Time to Solve", data: this_weeks_requests.solved_requests.group_by_hour(:solved_at).count},
    {name: "Average Queue", data: this_weeks_requests.group_by_hour(:created_at).count}]
  end
end
