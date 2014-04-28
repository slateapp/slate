class CohortsController < ApplicationController
  before_action :authenticate_teacher!, only: [:new, :create]
  def new
    @cohort = Cohort.new
  end

  def create
    @cohort = Cohort.new params[:cohort].permit(:name)
    if @cohort.save
      flash[:success] = "Cohort created successfully"
      redirect_to teachers_path
    else
      @cohort.errors.full_messages.each do |msg|
        flash[:error] = msg
      end
      render 'new'
    end
  end
end
