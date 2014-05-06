class TeachersController < ApplicationController
  before_action :authenticate_teacher!, only: [:dashboard, :update, :students, :edit_student]

  def dashboard
    @requests = Request.all
    @teacher, @cohorts, @cohort_options = current_teacher, cohorts_in_order, cohort_options
    @cohort = Cohort.find(selected_cohort) if selected_cohort
    @students = Student.where(cohort: selected_cohort, approved: true)    
    @stats = {
      todays_wait_time: Request.todays_average_wait_time.round,
      todays_queue: Request.todays_average_queue.round,
      # pie: Request.where(created_at: (Time.now-604800)..Time.now).group(:category).count,
      weekly_requests: Request.group_by_day(:created_at, last: 7).count,
      pie: Request.where(created_at: (Date.today.beginning_of_week)..Time.now).map{|request|
        [request.category.name, Request.where(created_at: (Date.today.beginning_of_week)..Time.now, category: request.category).count]
      }.uniq,
      leaderboard: Request.where(created_at: (Date.today.beginning_of_week)..Time.now).map{|request|
        if request.solved
          [request.teacher.name, Request.where(created_at: (Date.today.beginning_of_week)..Time.now, teacher: request.teacher).count]
        end
      }.uniq
    }
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
    @approved = Student.where(approved: true)
    @unapproved = Student.where(approved: false)
    params[:approved] ? (@students, @switch = @approved, "Unapprove") : (@students, @switch = @unapproved, "Approve")
  end

  def edit_student
    @student = Student.find params[:id]
    @cohort_options = cohort_options
  end

  private
  def selected_cohort
    params[:cohort] || @teacher.cohort
  end
end
