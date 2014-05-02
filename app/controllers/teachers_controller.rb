class TeachersController < ApplicationController
  before_action :authenticate_teacher!, only: [:dashboard, :update, :students,
    :approve_student, :unapprove_student, :delete_student, :edit_student]
  def dashboard
    @requests = Request.all
    @teacher = current_teacher
    @cohorts_list = Cohort.all.sort_by(&:name_to_date).reverse
    cohort = params[:cohort] ? params[:cohort] : @teacher.cohort
    @cohort = Cohort.find(cohort) if cohort
    @students = Student.where(cohort: cohort, approved: true)    
  end

  def update
    @teacher = current_teacher
    @cohort = Cohort.find params[:cohort][:id]
    @teacher.cohort = @cohort
    @teacher.save
    redirect_to dashboard_teachers_path
  end

  def students
    if params[:approved]
      @approved = Student.where(approved: true)
      @unapproved = Student.where(approved: false)
      @students = @approved
      @switch = "approved"
    else
      @approved = Student.where(approved: true)
      @unapproved = Student.where(approved: false)
      @students = @unapproved
      @switch = "unapproved"
    end
  end

  def approve_student
    @student = Student.find params[:id]
    @student.approve
    flash[:notice] = "#{@student.name} has been approved!"
    redirect_to students_teachers_path
  end

  def unapprove_student
    @student = Student.find params[:id]
    @student.unapprove
    flash[:notice] = "#{@student.name} has been unapproved!"
    redirect_to students_teachers_path(approved: true)
  end

  def delete_student
    @student = Student.find params[:id]
    @student.destroy
    flash[:notice] = "#{@student.name} has been deleted!"
    redirect_to :back
  end

  def edit_student
    @student = Student.find params[:id]
  end
end
