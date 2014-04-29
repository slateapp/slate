class Student < ActiveRecord::Base
	has_many :authorizations
	belongs_to :cohort
	validates :name, :email, :presence => true

  def approve
    self.approved = true
    self.save
  end

  def unapprove
    self.approved = false
    self.save
  end
end
