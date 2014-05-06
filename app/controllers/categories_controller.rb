class CategoriesController < ApplicationController
  before_action :authenticate_teacher!, only: [:index, :new, :create, :edit, :update, :destroy]
  
  def index
    @requests = Request.all
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    category_save('new')
  end

  def edit
    @category = Category.find params[:id]
  end

  def update
    @category = Category.find params[:id]
    @category.assign_attributes category_params
    category_save('edit')
  end

  def destroy
    @category = Category.find params[:id]
    @category.destroy
    flash[:success] = "Category deleted successfully"
    redirect_to categories_path
  end
end

def category_save(function)
  verb = function == "edit" ? "updated" : "created"
  if @category.save
      flash[:success] = "Category #{verb} successfully"
      redirect_to categories_path
    else
      @category.errors.full_messages.each{ |msg| flash[:error] = msg }
      render function
    end
end

def category_params
  params[:category].permit(:name)
end