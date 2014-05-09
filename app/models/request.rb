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
end
