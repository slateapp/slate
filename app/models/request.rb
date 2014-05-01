class Request < ActiveRecord::Base
	belongs_to :student
  def category_name
    Category.find(self.category.to_i).name
  end
end
