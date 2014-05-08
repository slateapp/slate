class TeachersController < ApplicationController
  before_action :authenticate_teacher!, only: [:dashboard, :update, :students, :edit_student]

  def dashboard
    @user, @cohorts, @cohort_options = current_teacher, cohorts_in_order, cohort_options
    @requests = Request.for_cohort(selected_cohort || Cohort.all)
    @cohort = Cohort.find(selected_cohort) if selected_cohort
    @students = Student.where(cohort: selected_cohort, approved: true).sort_by(&:requests)
    # raise "#{Request.todays_average_wait_time_for(selected_cohort)}"
    @stats = {
      todays_wait_time: Request.todays_average_wait_time_for(selected_cohort).round,
      todays_queue: Request.todays_average_queue_for(selected_cohort).round,
      weekly_requests: Request.for_cohort(selected_cohort || Cohort.all).group_by_day(:created_at, last: 7).count,
      pie: Request.weekly_request_categories_for(selected_cohort),
      leaderboard: Request.leaderboard_for(selected_cohort),
      weekly_issues_average_over_day: Request.weekly_issues_average_over_day_for(selected_cohort)
    }
  end

  def statistics
    @user, @cohorts, @cohort_options = current_teacher, cohorts_in_order, cohort_options
    @requests = Request.for_cohort(selected_cohort || Cohort.all)
    @stats = {
      todays_wait_time: Request.todays_average_wait_time_for(nil).round,
      todays_queue: Request.todays_average_queue_for(nil).round,
      weekly_requests: Request.for_cohort(Cohort.all).group_by_day(:created_at, last: 7).count,
      pie: Request.weekly_request_categories_for(nil),
      leaderboard: Request.leaderboard_for(nil),
      weekly_issues_average_over_day: Request.weekly_issues_average_over_day_for(nil)
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
    @user = current_teacher
    @requests = Request.for_cohort(selected_cohort || Cohort.all)
    @approved = Student.where(approved: true).sort_by(&:cohort).reverse
    @unapproved = Student.where(approved: false).sort_by(&:cohort).reverse
    params[:approved] ? (@students, @switch = @approved, "Unapprove") : (@students, @switch = @unapproved, "Approve")
  end

  def edit_student
    @student = Student.find params[:id]
    @cohort_options = cohort_options
  end
end
