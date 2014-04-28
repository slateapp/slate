class StudentsController < ApplicationController
	def new
  end

  def create
  	auth_hash = request.env['omniauth.auth']
  	# raise auth_hash.to_hash.inspect

		@authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
		
	  if @authorization
	    # render :text => "Welcome back #{@authorization.student.name}! You have already signed up."
	    student = @authorization.student
	  else
	    student = Student.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
	    student.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
	    student.save
		# render :text => "Hi #{student.name}! Awesome, you've signed up."
  	end

  	session[:student_id] = student.id
		redirect_to get_cohort_path
  end

  def index
  end

  def failure
	  render :text => "Sorry, but you didn't allow access to our app!"
	end

  def destroy
	  session[:student_id] = nil
	  render :text => "You've logged out!"
	end

	def cohort
		@student = current_student
	end


end
