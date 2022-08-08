# frozen_string_literal: true

# Category model

class Category < ActiveRecord::Base
  has_many :requests
  validates :name, uniqueness: true
end
