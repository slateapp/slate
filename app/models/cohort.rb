class Cohort < ActiveRecord::Base
	has_many :students
  def name_to_date
    Date.parse(self.name)
  end
end
