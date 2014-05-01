class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = "Cohort created successfully"
      redirect_to categories_path
    else
      @category.errors.full_messages.each do |msg|
        flash[:error] = msg
      end
      render 'new'
    end
  end
end

def category_params
  params[:category].permit(:name)
end