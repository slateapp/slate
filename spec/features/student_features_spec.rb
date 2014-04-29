require 'spec_helper'

describe 'Student login with Github' do 
	context 'new student logging in via Github' do 
		it 'has a login button' do
			visit '/'

			expect(page).to have_content 'Login with Github'
		end

		it 'should redirect student to Github login page', js: true do 
			visit '/'
			click_link 'Login with Github'

			expect(current_url).to match /github.com/
		end
		
		context 'mock omniauth' do
			before { set_omniauth }

			it 'should redirect from GitHub to successful login page' do
				visit '/'
				click_link 'Login with Github'

				expect(page).to have_content "Hi Alex Peattie! Awesome, you've signed up!"
			end

			it 'should redirect from GitHub to successful login page' do
				visit '/'
				click_link 'Login with Github'

				expect(current_url).to match /cohort/
			end

			it 'should be able to select a cohort' do
				visit '/'
				click_link 'Login with Github'

				expect(page).to have_content "Select cohort"
			end
			
			context 'setting cohort' do
				it 'should add cohort to student' do
					cohort = create :february
					visit '/'
					click_link 'Login with Github'
					select('February 2014', :from => 'cohort_id')
					click_button "Submit"
					expect(Student.last.cohort).to eq cohort
				end
			end
		end

		context 'previous student logs in via GitHub' do
			before { set_omniauth }

			before do
				student = create :student
				student.authorizations.create(provider: 'github', uid: '1234')
			end

			it 'should redirect from GitHub to successful login page' do
				visit '/'
				click_link 'Login with Github'

				expect(current_url).to match /dashboard/
			end
		end


	end
end

