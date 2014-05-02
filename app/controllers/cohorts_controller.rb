class CohortsController < ApplicationController
  before_action :authenticate_teacher!, only: [:new, :create, :index, :edit]
  
  def index
    @cohorts_list = Cohort.all.sort_by(&:name_to_date).reverse
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
      @cohort.errors.full_messages.each do |msg|
        flash[:error] = msg
      end
      render 'new'
    end
  end

  def edit
    @cohort = Cohort.find params[:id]
  end

  def update
    authenticate_teacher!
    @cohort = Cohort.find params[:id]
    @cohort.update cohort_params
    flash[:success] = "Cohort updated successfully"
    redirect_to cohorts_path
  end

  def destroy
    @cohort = Cohort.find params[:id]
    @cohort.destroy
    redirect_to cohorts_path
  end
end

def cohort_params
  params[:cohort].permit(:name)
end
