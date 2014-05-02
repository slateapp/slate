class StudentCannotSolve < Exception
end

class Request < ActiveRecord::Base
	belongs_to :student
  validates :category, :description, :presence => true
  def category_name
    Category.find(self.category.to_i).name
  end

  def solve!
  	self.solved = true
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
end
