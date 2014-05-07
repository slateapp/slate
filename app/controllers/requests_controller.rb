class RequestsController < ApplicationController
	before_action :authenticate!, only: [:new, :create, :destroy, :edit]
  before_filter :deny_to_unapproved, only: [:new, :create, :edit, :update, :destroy]
	
	def index
		@requests = Request.for_cohort((params[:cohort] || current_user.try(:cohort)) || Cohort.all).where(solved: false).sort {|a,b| a.created_at <=> b.created_at}
	end

	def display
		@cohort_one = Cohort.where(selected: true).first
		@cohort_two = Cohort.where(selected: true).second

		@requests_for_cohort_one = Request.for_cohort(@cohort_one || Cohort.all).where(solved: false).sort {|a,b| a.created_at <=> b.created_at}
		@requests_for_cohort_two = Request.for_cohort(@cohort_two || Cohort.all).where(solved: false).sort {|a,b| a.created_at <=> b.created_at}
	end

	def show
		@request = Request.find(params[:id])
	end

	def new 
		if current_student
			@request = Request.new
		else
			flash[:notice] = 'Sorry, you must be a student to make a request'
			redirect_to '/'
		end
	end

	def create
		if current_student.requests.where(solved: false).any?
			flash[:notice] = 'You already have an active request.'
			redirect_to students_dashboard_path
		else
			@request = Request.new params[:request].permit(:description)
			@request.student = current_student
			@request.category = Category.find params[:request][:category] if !params[:request][:category].empty?

			if @request.save
				WebsocketRails[:request_created].trigger 'new', @request
				redirect_to students_dashboard_path, :notice => "Your request has been created."
			else
				flash[:error] = "Error: Please fill out all fields"
				redirect_to students_dashboard_path
			end
		end
	end 

	def edit
		@request = current_student ? (current_student.requests.find params[:id]) : (Request.find params[:id])
		flash[:notice] = 'Request was successfully updated.'
		rescue ActiveRecord::RecordNotFound
			flash[:notice] = 'Error: This is not your post'
			redirect_to students_dashboard_path
	end

	def update
	  @request = Request.find(params[:id])
	  @request.category = Category.find params[:request][:category] if !params[:request][:category].empty?
	  if @request.update_or_solve((params[:request].permit(:description, :category, :solved)), current_user)
			WebsocketRails[:request_edited].trigger 'edit', @request.id
      flash[:notice] = 'Request was successfully updated.'
      redirect_to students_dashboard_path
	  else
	    render 'edit'
		end
		rescue StudentCannotSolve
		flash[:notice] = "Please sign in as a teacher"
	end

	def destroy
		@request = current_student ? (current_student.requests.find params[:id]) : (Request.find params[:id])
		@request.destroy
		WebsocketRails[:request_deleted].trigger 'destroy', @request.id
		flash[:notice] = 'Request deleted'
		redirect_to students_dashboard_path

	rescue ActiveRecord::RecordNotFound
		flash[:notice] = 'Error: This is not your post'
		redirect_to students_dashboard_path
	end

	def current_user
		current_teacher || current_student
	end
end
