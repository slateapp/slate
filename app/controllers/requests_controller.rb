class RequestsController < ApplicationController
	before_action :authenticate!, only: [:new, :create, :destroy, :edit]
	
	def index
		@requests = Request.where(solved: false)
		@requests = Request.all.sort {|a,b| a.created_at <=> b.created_at}
	end

	def show
		@request = Request.find(params[:id])
	end

	def new 
		if current_student
			@request = Request.new
		else
			flash[:notice] = 'Sorry, you must be a student to make a request'
			redirect_to requests_path
		end
	end

	def create
		@request = Request.new params[:request].permit(:description, :category)
		@request.student = current_student

		if @request.save
			WebsocketRails[:request_created].trigger 'new', @request
			redirect_to '/requests', :notice => "Your request has been created."
		else
			flash[:error] = "Error: Please fill out all fields"
			render "new"
		end
	end 

	def edit
		@request = current_student ? (current_student.requests.find params[:id]) : (Request.find params[:id])
		flash[:notice] = 'Request was successfully updated.'
		rescue ActiveRecord::RecordNotFound
			flash[:notice] = 'Error: This is not your post'
			redirect_to '/requests'
	end

	def update
	  @request = Request.find(params[:id])

	  if @request.update_or_solve((params[:request].permit(:description, :category, :solved)), current_user)
	      flash[:notice] = 'Request was successfully updated.'
	      redirect_to requests_path
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
		redirect_to requests_path

	rescue ActiveRecord::RecordNotFound
		flash[:notice] = 'Error: This is not your post'
		redirect_to requests_path
	end

	def current_user
		current_teacher || current_student
	end
end
