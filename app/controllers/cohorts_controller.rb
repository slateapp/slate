class CohortsController < ApplicationController
  before_action :authenticate_teacher!, only: [:index, :new, :create, :edit, :update, :destroy]
  
  def index
    @cohorts = Cohort.all.sort_by(&:name_to_date).reverse
    @cohort_options = @cohorts.map { |cohort| [cohort.name, cohort.id] }
  end

  def new
    @cohort = Cohort.new
  end

  def create
    @cohort = Cohort.new cohort_params
    if @cohort.save
      flash[:success] = "Cohort created successfully"
      redirect_to cohorts_path
    else
      @cohort.errors.full_messages.each { |msg| flash[:error] = msg }
      render 'new'
    end
  end

  def edit
    @cohort = Cohort.find params[:id]
  end

  def update
    @cohort = Cohort.find params[:id]
    @cohort.assign_attributes cohort_params
    if @cohort.save
      flash[:success] = "Cohort updated successfully"
      redirect_to cohorts_path
    else
      @cohort.errors.full_messages.each{ |msg| flash[:error] = msg }
      render 'edit'
    end
  end

  def destroy
    @cohort = Cohort.find params[:id]
    @cohort.destroy
    redirect_to cohorts_path
  end
end

def cohort_params
  params[:cohort].permit(:month, :year)
end
