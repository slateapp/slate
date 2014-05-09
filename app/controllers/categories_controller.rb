class CategoriesController < ApplicationController
  before_action :authenticate_teacher!, only: [:index, :new, :create, :edit, :update, :destroy]
  
  def index
    @user = current_teacher
    @requests = Request.for_cohort(selected_cohort || Cohort.all)
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    create_or_update('new', "Category", @category, categories_path)
  end

  def edit
    @category = Category.find params[:id]
  end

  def update
    @category = Category.find params[:id]
    @category.assign_attributes category_params
    create_or_update('edit', "Category", @category, categories_path)
  end

  def destroy
    @category = Category.find params[:id]
    @category.destroy
    flash[:success] = "Category deleted successfully"
    redirect_to categories_path
  end
end

def category_params
  params[:category].permit(:name)
end