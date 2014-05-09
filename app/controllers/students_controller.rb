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
    # params[:batch_action] == "Approve" ? approve_all : unapprove_all
    params[:batch_action] == "Approve" ? approve_or_unapprove_all(true, "approve") : approve_or_unapprove_all(false, "unapprove")
  end

  def update
    student = from_teacher? ? (Student.find params[:id]) : current_student
    set_cohort(student) if params[:cohort]
    student.name = params[:student][:name] if from_teacher? && params[:student]
    approval(student)
    student.save
    redirection
  end
end

private 

# def approve_all
#   students = Student.where(approved: false)
#   if students.count == 0
#     redirect_to students_teachers_path, notice: "There are no students to approve"
#   else
#     WebsocketRails[:student_batch_approval].trigger 'student_batch_approval', students
#     students.update_all(approved: true)
#     redirect_to students_teachers_path(approved: true), notice: "You successfully approved all the students"
#   end
# end

# def unapprove_all
#   students = Student.where(approved: true)
#   if students.count == 0
#     redirect_to students_teachers_path(approved: true), notice: "There are no students to unapprove"
#   else
#     WebsocketRails[:student_batch_approval].trigger 'student_batch_approval', students
#     students.update_all(approved: false)
#     redirect_to students_teachers_path, notice: "You successfully unapproved all the students"
#   end
# end

def approve_or_unapprove_all(function, verb)
  students = Student.where(approved: !function)
  if students.count == 0
    redirect_to students_teachers_path, notice: "There are no students to #{verb}"
  else
    WebsocketRails[:student_batch_approval].trigger 'student_batch_approval', students
    students.update_all(approved: function)
    redirect_to students_teachers_path, notice: "You successfully #{verb}d all the students"
  end
end

def set_cohort(student)
  return redirect_to edit_student_teachers_path(id: params[:id]), notice: "No cohort selected, please select a cohort" if params[:cohort][:id].empty?
  student.cohort = Cohort.find params[:cohort][:id]
end

def redirection
  flash[:notice] = "Student successfully updated" if from_teacher?
  if from_teacher? && params[:approve]
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

def approval(student)
  if params[:approve]
    student.approved ? student.unapprove : student.approve
    WebsocketRails[:student_approval].trigger 'student_approval', student
  end
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