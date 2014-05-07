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
  	@user = current_student
    @requests = Request.for_cohort(selected_cohort || Cohort.all)
    @request = Request.new
  	redirect_to dashboard_teachers_path if current_teacher
  end

  def failure
	  render :text => "Sorry, but you haven't allowed SL8 to access your GitHub so we cannot sign you up!"
	end

  def destroy
    from_teacher? ? destroy_student : destroy_session
	end

	def cohort
		@cohorts_list = Cohort.all.sort_by(&:name_to_date).reverse
    @cohort_options = cohort_options
	end

  def batch_change
    if params[:batch_action] == "Approve"
      unapproved_students = Student.where(approved: false)
      if unapproved_students.count == 0
        flash[:error] = "There are no students to approve"
        redirect_to students_teachers_path
      else
        unapproved_students.update_all(approved: true)
        flash[:success] = "You successfully approved all the students"
        redirect_to students_teachers_path(approved: true)
      end
    else
      approved_students = Student.where(approved: true)
      if approved_students.count == 0
        flash[:error] = "There are no students to approve"
        redirect_to students_teachers_path(approved: true)
      else
        approved_students.update_all(approved: false)
        flash[:success] = "You successfully unapproved all the students"
        redirect_to students_teachers_path
      end
    end
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
  flash[:notice] = "Welcome back #{student.name}."
  redirect_to students_dashboard_path
  student
end

def create_new_student(auth_hash)
  student = Student.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
  student.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
  student.save
  flash[:notice] = "Hi #{student.name}, welcome to SL8."
  redirect_to get_cohort_path
  student
end

def destroy_session
  session[:student_id] = nil
  flash[:notice] = "You have successfully signed out!"
  redirect_to root_path
end

def destroy_student
  student = Student.find params[:id]
  student.destroy
  flash[:notice] = "#{student.name} has been deleted!"
  redirect_to :back
end