class TeachersController < ApplicationController
  before_action :authenticate_teacher!, only: [:dashboard]
  def dashboard
    @teacher = current_teacher
  end
end
