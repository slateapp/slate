class Student < ActiveRecord::Base
	has_many :authorizations
	belongs_to :cohort
	validates :name, :email, :presence => true
end
