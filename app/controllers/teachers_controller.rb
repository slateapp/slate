class TeachersController < ApplicationController
  before_action :authenticate_teacher!, only: [:dashboard, :update, :students,
    :approve_student, :unapprove_student, :delete_student, :edit_student]

  def dashboard
    @requests = Request.all
    @teacher, @cohorts, @cohort_options = current_teacher, cohorts_in_order, cohort_options

    @cohort = Cohort.find(selected_cohort) if selected_cohort
    @students = Student.where(cohort: selected_cohort, approved: true)    
  end

  def update
    teacher = current_teacher
    teacher.cohort = Cohort.find params[:cohort][:id]
    if teacher.save
      flash[:success] = "Default cohort updated successfully"
      redirect_to cohorts_path
    else
      teacher.errors.full_messages.each{ |msg| flash[:error] = msg }
      redirect_to dashboard_teachers_path
    end
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

  private
  def selected_cohort
    params[:cohort] || @teacher.cohort
  end

  def cohorts_in_order
    Cohort.all.sort_by(&:name_to_date).reverse
  end

  def cohort_options
    cohorts_in_order.map { |cohort| [cohort.name, cohort.id] }  
  end
end
