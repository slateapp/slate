class StudentsController < ApplicationController
  before_filter :deny_to_unapproved, only: [:index]
	def new
  end

  def create
  	auth_hash = request.env['omniauth.auth']
		authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
		student = authorization ? create_new_session(authorization) : create_new_student(auth_hash)
	  session[:student_id] = student.id
  end

  def index
  	@requests = Request.all
  	redirect_to dashboard_teachers_path if current_teacher
  end

  def failure
	  render :text => "Sorry, but you didn't allow access to our app!"
	end

  def destroy
    from_teacher? ? destroy_student : destroy_session
	end

	def cohort
		@cohorts_list = Cohort.all.sort_by(&:name_to_date).reverse
    @cohort_options = cohort_options
	end

	def update
    student = from_teacher? ? (Student.find params[:id]) : current_student
    if params[:cohort]
      if params[:cohort][:id].empty?
        flash[:error] = "No cohort selected, please select a cohort"
        redirect_to edit_student_teachers_path(id: params[:id])
        return false
      else
        cohort = Cohort.find params[:cohort][:id]
      end
    end
    student.cohort = cohort if cohort
    student.name = params[:student][:name] if from_teacher? && params[:student]
    if approval?
      student.approved ? student.unapprove : student.approve
    end
    student.save
    flash[:notice] = "Student successfully updated" if from_teacher?
    redirection
  end
end

private 

def redirection
  if from_teacher? && approval?
    redirect_to :back
  elsif from_teacher?
    redirect_to students_teachers_path(approved: true)
  elsif current_student && !current_student.approved
    redirect_to students_require_approval_path
  else
    redirect_to students_dashboard_path
  end  
end

def from_teacher?
  params[:teacher]
end

def approval?
  params[:approve]
end

def create_new_session(authorization)
  student = authorization.student
  flash[:notice] = "Hi #{student.name}! Awesome, welcome back."
  redirect_to students_dashboard_path
  student
end

def create_new_student(auth_hash)
  student = Student.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
  student.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
  student.save
  flash[:notice] = "Hi #{student.name}! Awesome, you've signed up!"
  redirect_to get_cohort_path
  student
end

def destroy_session
  session[:student_id] = nil
  flash[:notice] = "You have now signed out!"
  redirect_to root_path
end

def destroy_student
  student = Student.find params[:id]
  student.destroy
  flash[:notice] = "#{student.name} has been deleted!"
  redirect_to :back
end