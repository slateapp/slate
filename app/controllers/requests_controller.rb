class RequestsController < ApplicationController

	def index
		@requests = Request.all
	end

	def show
		@request = Request.find(params[:id])
	end

	def new 
		@request = Request.new
	end

	def create
		@request = Request.new params[:request].permit(:description, :category)

		if @request.save
			redirect_to '/requests', :notice => "Your request has been created."
		else
			render "new"
		end
	end

	def description
		raise "Error description"
	end



end
