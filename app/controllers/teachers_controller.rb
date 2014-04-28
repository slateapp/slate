class TeachersController < ApplicationController
  before_action :authenticate_teacher!, only: [:index]
  def index
    @teacher = current_teacher
  end
end
