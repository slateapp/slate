class RequestsController < ApplicationController
	before_action :authenticate_student!, only: [:new, :create, :destroy]
	
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
			redirect_to '/requests', :notice => "Your request has been created."
			WebsocketRails[:requests].trigger 'new', { description: @request.description }
		else
			render "new"
		end
	end 

	def edit
		@request = Request.find(params[:id])
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

		flash[:notice] = 'Request deleted'
		redirect_to '/'

	rescue ActiveRecord::RecordNotFound
		flash[:notice] = 'Error: This is not your post'
		redirect_to '/'
	end 
end
