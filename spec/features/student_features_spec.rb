require 'spec_helper'

describe 'Student login with Github' do 
	context 'Navigating to Github' do 
		it 'has a login button' do
			visit '/students/login'

			expect(page).to have_content 'Login with Github'
		end

		it 'should redirect student to Github login page', js: true do 
			visit '/students/login'
			click_link 'Login with Github'

			expect(current_url).to match /github.com/
		end
		
		context 'mock omniauth' do
			before { set_omniauth }

			it 'should redirect from GitHub to successful login page' do
				visit '/students/login'
				click_link 'Login with Github'

				expect(current_url).to match /cohort/
				expect(page).to have_content "Hi Alex Peattie! Awesome, you've signed up."
			end
		end
			
	end	
				
	
end

# before do
# 	student = Student.create(email: 'alex@example.com', name: 'Alex Peattie')
# 	student.authorizations.create(provider: 'github', uid: '1234')
# end