class Category < ActiveRecord::Base
  validates :name, uniqueness: true
end
