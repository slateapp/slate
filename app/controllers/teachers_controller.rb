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

  def students
    @unapproved = Student.where(approved: false)
  end

  def approve_student
    @student = Student.find params[:id]
    @student.approve
    flash[:notice] = "#{@student.name} has been approved!"
    redirect_to students_teachers_path
  end
end
