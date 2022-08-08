# frozen_string_literal: true

# PagesController
class PagesController < ApplicationController
  def index
    redirect_to students_dashboard_path if current_student && current_student.approved
    redirect_to dashboard_teachers_path if current_teacher
  end

  def require_approval
    redirect_to students_dashboard_path if current_student.approved
  end

  def current_user
    render json: current_student
  end
end
