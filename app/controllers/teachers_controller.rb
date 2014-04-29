class TeachersController < ApplicationController
  before_action :authenticate_teacher!, only: [:dashboard]
  def dashboard
    @teacher = current_teacher
    @default = Cohort.find(@teacher.cohort) if @teacher.cohort
  end

  def update
    @teacher = current_teacher
    @cohort = Cohort.find params[:cohort][:id]
    @teacher.cohort = @cohort
    @teacher.save
    redirect_to dashboard_teachers_path
  end
end
