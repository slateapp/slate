# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_student

  def create_or_update(function, record_name, record, path)
    verb = function == 'edit' ? 'updated' : 'created'
    if record.save
      current_teacher.twilio_info = record if record_name == 'Twilio Information'
      flash[:success] = "#{record_name} #{verb} successfully."
      redirect_to path
    else
      record.errors.full_messages.each { |msg| flash[:error] = msg }
      render function
    end
  end

  def after_sign_in_path_for(resource)
    case resource
    when Teacher then dashboard_teachers_path
    end
  end

  def current_student
    return unless session[:student_id]

    Student.find session[:student_id]
  rescue ActiveRecord::RecordNotFound
    session[:student_id] = nil
  end

  def deny_to_unapproved
    unless current_teacher && (current_student.approved == true)
      flash[:error] = 'Error: you are still awaiting approval!'
      redirect_to root_path
    end
  end

  def authenticate!
    unless current_student || current_teacher
      flash[:notice] = 'You need to sign in!'
      redirect_to students_dashboard_path
    end
  end

  def cohorts_in_order
    Cohort.all.sort_by(&:name_to_date).reverse
  end

  def cohort_options
    cohorts_in_order.map { |cohort| [cohort.name, cohort.id] }
  end

  def selected_cohort
    params[:cohort] || @user.try(:cohort)
  end
end
