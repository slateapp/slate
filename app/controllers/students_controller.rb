class StudentsController < ApplicationController
  before_filter :deny_to_unapproved, only: [:index]
	def new
  end

  def create
  	auth_hash = request.env['omniauth.auth']
  	# raise auth_hash.to_hash.inspect

		@authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
		
	  if @authorization
	    student = @authorization.student
			flash[:notice] = "Hi #{student.name}! Awesome, welcome back."
	    redirect_to students_dashboard_path

	  else
	    student = Student.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
	    student.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
	    student.save
			flash[:notice] = "Hi #{student.name}! Awesome, you've signed up!"
			redirect_to get_cohort_path
  	end
  	
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
    if from_teacher?
      student = Student.find params[:id]
      student.destroy
      flash[:notice] = "#{student.name} has been deleted!"
      redirect_to :back
    else
  	  session[:student_id] = nil
  	  flash[:notice] = "You have now signed out!"
  	  redirect_to root_path
    end
	end

	def cohort
		@cohorts_list = Cohort.all.sort_by(&:name_to_date).reverse
	end

	def update
    student = from_teacher? ? (Student.find params[:id]) : current_student
		cohort = Cohort.find params[:cohort][:id] if params[:cohort]
	  student.cohort = cohort
    student.name = params[:student][:name] if from_teacher? && params[:student]
    if approval?
      student.approved ? student.unapprove : student.approve
    end
	  student.save
    flash[:notice] = "Student successfully updated" if from_teacher?
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
end

def from_teacher?
  params[:teacher]
end

def approval?
  params[:approve]
end