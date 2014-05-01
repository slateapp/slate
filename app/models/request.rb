class Request < ActiveRecord::Base
	belongs_to :student
  validates :category, :description, :presence => true
  def category_name
    Category.find(self.category.to_i).name
  end
end
