class Category < ActiveRecord::Base
  has_many :requests
  validates :name, uniqueness: true
end
