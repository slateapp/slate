require 'spec_helper'

describe 'Students sign in and out' do 
	context 'A new student signs up via GitHub' do
		before { set_omniauth } 

		it 'can view sign in button' do
			visit '/'

			expect(page).to have_content 'Sign in with GitHub'
		end

		it 'can click a link to GitHub login page' do 
			visit '/'
			find_link('Sign in with GitHub')[:href].should match /github/i
		end
	
		it 'is redirected from GitHub to an awaiting approval page' do
			visit '/'
			click_link 'Sign in with GitHub'

			expect(page).to have_content "Hi Alex Peattie! Awesome, you've signed up!"
		end

		it 'is redirected from GitHub to select cohort page' do
			visit '/'
			click_link 'Sign in with GitHub'

			expect(current_url).to match /cohort/
		end

		it 'can select a cohort' do
			visit '/'
			click_link 'Sign in with GitHub'

			expect(page).to have_content "Select cohort"
		end
	end

	context 'An approved student signs in/out' do
		let(:student){create :student}
		before do
			set_omniauth
			student.authorizations.create(provider: 'github', uid: '1234')
			student.approve
			student.cohort = create :february
			student.save
			visit '/'
			click_link 'Sign in with GitHub'
		end

		it 'is redirected from GitHub to welcome dashboard' do
			expect(current_url).to match /dashboard/
			expect(page).to have_content 'Awesome, welcome back.'
		end

		it 'can see a Sign Out link on the dashboard' do
			visit '/students/dashboard'
			expect(current_url).to match /dashboard/
			expect(page).to have_link "Sign Out"
		end
		
		it 'is redirected to the sign in page' do
			visit '/students/dashboard'
			click_link "Sign Out"

			expect(current_url).to match '/'
		end
	end
end

# context 'setting cohort' do
# 				xit 'should add cohort to student' do
# 					# This needs to be a controller or a model test, to ensure to cohort is being set
# 					cohort = create :february
# 					visit '/'
# 					click_link 'Sign in with GitHub'
# 					select('February 2014', :from => 'cohort_id')
# 					click_button "Submit"
# 					expect(Student.last.cohort).to eq cohort
# 				end
# 			end
# 		end
