class RequestsController < ApplicationController
	before_action :authenticate_student!, only: [:new, :create, :destroy, :edit]
	
	def index
		@requests = Request.all
	end

	def show
		@request = Request.find(params[:id])
	end

	def new 
		raise 'No' unless current_student
		@request = Request.new
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
		@request = current_student.requests.find params[:id]

		flash[:notice] = 'Request was successfully updated.'

	rescue ActiveRecord::RecordNotFound
		flash[:notice] = 'Error: This is not your post'
		redirect_to '/requests'

	end

	def update
	  @request = Request.find(params[:id])

	    if @request.update_attributes(params[:request].permit(:description, :category))
	      flash[:notice] = 'Request was successfully updated.'
	      redirect_to requests_path
	    else
	      render 'edit'
		end
	end


	def destroy
		@request = current_student.requests.find params[:id]
		@request.destroy
		WebsocketRails[:request_deleted].trigger 'destroy', @request.id
		flash[:notice] = 'Request deleted'
		redirect_to '/requests'

	rescue ActiveRecord::RecordNotFound
		flash[:notice] = 'Error: This is not your post'
		redirect_to '/'
	end 
end
