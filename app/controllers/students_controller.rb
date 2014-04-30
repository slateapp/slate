class StudentsController < ApplicationController
	def new
  end

  def create
  	auth_hash = request.env['omniauth.auth']
  	# raise auth_hash.to_hash.inspect

		@authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
		
	  if @authorization
	    student = @authorization.student
			flash[:notice] = "Hi #{student.name}! Awesome, you came back to us."
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

  # def student_signed_in?
  # 	@authorization.student
  # end

  def index
  end

  def failure
	  render :text => "Sorry, but you didn't allow access to our app!"
	end

  def destroy
	  session[:student_id] = nil
	  flash[:notice] = "You have now logged out!"
	  redirect_to root_path
	end

	def cohort
		@student = current_student
		@cohorts = Cohort.all
	end

	def update
    @student = from_teacher? ? (Student.find params[:id]) : current_student
		@cohort = Cohort.find params[:cohort][:id]
	  @student.cohort = @cohort
    @student.name = params[:student][:name] if from_teacher?
	  @student.save
    flash[:notice] = "Student successfully updated" if from_teacher?
	  from_teacher? ? (redirect_to students_teachers_path(approved: true)) : (redirect_to students_dashboard_path)
 	end
end

def from_teacher?
  params[:teacher]
end
