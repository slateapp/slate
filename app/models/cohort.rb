class Cohort < ActiveRecord::Base
	has_many :students
  validates :month, :year, presence: true
  validate :cohort_uniqueness

  def cohort_uniqueness
    existing_record = Cohort.where(month: month, year: year).count
    errors.add(month + " " + year, "has already been created!") if existing_record > 0
  end

  def name
    self.month + " " + self.year
  end

  def name_to_date
    Date.parse(self.name)
  end
end
