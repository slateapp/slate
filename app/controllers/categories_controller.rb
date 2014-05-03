class CategoriesController < ApplicationController
  before_action :authenticate_teacher!, only: [:index, :new, :create, :edit, :update, :destroy]
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
      @category.errors.full_messages.each{ |msg| flash[:error] = msg }
      render 'new'
    end
  end

  def edit
    @category = Category.find params[:id]
  end

  def update
    @category = Category.find params[:id]
    @category.assign_attributes category_params
    if @category.save
      flash[:success] = "Category updated successfully"
      redirect_to categories_path
    else
      @category.errors.full_messages.each{ |msg| flash[:error] = msg }
      render 'edit'
    end
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