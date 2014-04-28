class Authorization < ActiveRecord::Base
	belongs_to :student
	validates :provider, :uid, :presence => true
end
