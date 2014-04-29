class TeachersController < ApplicationController
  before_action :authenticate_teacher!, only: [:dashboard]
  def dashboard
    @teacher = current_teacher
  end

  def update
    @teacher = current_teacher
    @cohort = Cohort.find params[:cohort][:id]
    @teacher.cohort = @cohort.name
    @teacher.save
    redirect_to dashboard_teachers_path
  end
end
