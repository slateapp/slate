class PagesController < ApplicationController
  def new
  end

  def create
  	auth_hash = request.env['omniauth.auth']

		@authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
		  if @authorization
		    render :text => "Welcome back #{@authorization.student.name}! You have already signed up."
		  else
		    student = Student.new :name => auth_hash["student_info"]["name"], :email => auth_hash["student_info"]["email"]
		    student.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
		    student.save

  	render :text => auth_hash.inspect
  end

  def index
  end
end
