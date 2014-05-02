class Cohort < ActiveRecord::Base
	has_many :students
  validates :month, :year, :presence => true
  
  def name
    self.month + " " + self.year
  end

  def name_to_date
    Date.parse(self.name)
  end
end
