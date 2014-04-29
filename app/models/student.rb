class Student < ActiveRecord::Base
	has_many :authorizations
	validates :name, :email, :presence => true
end
