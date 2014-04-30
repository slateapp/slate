require 'spec_helper'

describe 'Pages' do
	context "should redirect to dashboard if signed in" do
		specify "as student" do
			sign_in_as_student_alex
			visit '/'
			expect(current_url).to match /dashboard/
		end
		specify "as teacher" do
			login_as create :teacher
			visit '/'
			expect(current_url).to match /dashboard/
		end
	end
end