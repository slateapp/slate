class RequestsController < ApplicationController
	before_action :authenticate!, only: [:new, :create, :destroy, :edit]
  before_filter :deny_to_unapproved, only: [:new, :create, :edit, :update, :destroy]
	
	def index
		@requests = Request.for_cohort((params[:cohort] || current_user.try(:cohort)) || Cohort.all).where(solved: false).sort {|a,b| a.created_at <=> b.created_at}
	end

	def show
		@request = Request.find(params[:id])
	end
	
	def new 
		current_student ? (@request = Request.new) : (redirect_to root_path, notice: 'Sorry, you must be a student to make a request!')
	end

	def create
		if current_student.requests.unsolved_requests.any?
			redirect_to students_dashboard_path, notice: 'You already have an active request.'
		else
			@request = Request.new params[:request].permit(:description)
			set_category_and_student(@request, params[:request][:category])
			create_and_trigger_websocket('new', @request, :request_created, students_dashboard_path)
		end
	end 

	def edit
		@request = current_student ? (current_student.requests.find params[:id]) : (Request.find params[:id])
	rescue ActiveRecord::RecordNotFound
		redirect_to students_dashboard_path, notice: 'Error: This is not your post!'
	end

	def update
	  @request = Request.find(params[:id])
	  set_category(@request, params[:request][:category])
		update_and_trigger_websocket((params[:request].permit(:description, :category, :solved)), 'edit', @request, :request_edited, students_dashboard_path)
	rescue StudentCannotSolve
		flash[:notice] = "Please sign in as a teacher!"
	end

	def destroy
		@request = current_student ? (current_student.requests.find params[:id]) : (Request.find params[:id])
		@request.destroy
		WebsocketRails[:request_deleted].trigger 'destroy', @request.id
		flash[:notice] = 'Request deleted.'
	rescue ActiveRecord::RecordNotFound
		redirect_to students_dashboard_path, notice: 'Error: This is not your post!'
	end

	def display
		redirect_to root_path, notice: "Please ask a teacher to select current cohorts." if Cohort.where(selected: true).count != 2
		@cohort_one, @cohort_two = Cohort.current_cohorts.first, Cohort.current_cohorts.second
		@requests_for_cohort_one, @requests_for_cohort_two = get_requests(@cohort_one), get_requests(@cohort_two)
	end

end

private
def create_and_trigger_websocket(function, record, websocket, path)
	if record.save
		WebsocketRails[websocket].trigger function, record
		redirect_to path, notice: "Your request has been created."
	else
		flash[:error] = record.errors.full_messages.join(', ')
		redirect_to path
	end
end

def update_and_trigger_websocket(params, function, record, websocket, path)
	if @request.update_or_solve(params, current_user)
		WebsocketRails[websocket].trigger function, record.id
    redirect_to path, notice: "Request was successfully updated."
	else
    render 'edit', notice: "An error occured"
	end
end

def current_user
	current_teacher || current_student
end

def get_requests(cohort)
	Request.for_cohort(cohort || Cohort.all).unsolved_requests.sort{|a,b| a.created_at <=> b.created_at}
end

def set_category_and_student(record, id)
	record.student = current_student
	set_category(record, id)
end

def set_category(record, id)
	return if !id || id.try(:empty?)
	record.category = Category.find(id)
end