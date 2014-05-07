class Student < ActiveRecord::Base
  include Gravtastic
  gravtastic :secure => true,
              :size => 55
	has_many :authorizations
  has_many :requests
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
