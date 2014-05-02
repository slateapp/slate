require 'spec_helper'

describe 'Student login with GitHub' do 
	context 'new student logging in via GitHub' do 
		it 'has a login button' do
			visit '/'

			expect(page).to have_content 'Sign in with GitHub'
		end

		it 'should have a link to GitHub login page' do 
			visit '/'
			find_link('Sign in with GitHub')[:href].should match /github/i
	
		end
		
		context 'mock omniauth' do
			before { set_omniauth }

			it 'should redirect from GitHub to an awaiting approval page' do
				visit '/'
				click_link 'Sign in with GitHub'

				expect(page).to have_content "Hi Alex Peattie! Awesome, you've signed up!"
			end

			it 'should redirect from GitHub to successful login page' do
				visit '/'
				click_link 'Sign in with GitHub'

				expect(current_url).to match /cohort/
			end

			it 'should be able to select a cohort' do
				visit '/'
				click_link 'Sign in with GitHub'

				expect(page).to have_content "Select cohort"
			end
			
			context 'setting cohort' do
				xit 'should add cohort to student' do
					# This needs to be a controller or a model test, to ensure to cohort is being set
					cohort = create :february
					visit '/'
					click_link 'Sign in with GitHub'
					select('February 2014', :from => 'cohort_id')
					click_button "Submit"
					expect(Student.last.cohort).to eq cohort
				end
			end
		end

		context 'previous student logs in via GitHub' do
			let(:student){create :student}
			before do
				set_omniauth
				student.authorizations.create(provider: 'github', uid: '1234')
				student.approve
				student.cohort = create :february
				student.save
			end

			it 'should redirect from GitHub to successful login page' do
				visit '/'
				click_link 'Sign in with GitHub'
				expect(current_url).to match /dashboard/
			end
		end


	end
end

describe 'Student signs out' do

	let(:student){create :student}
	before do
		set_omniauth
		student.authorizations.create(provider: 'github', uid: '1234')
		student.cohort = create :february
		student.save
		visit '/'
		click_link 'Sign in with GitHub'
	end

	it 'should have a sign out button' do
		expect(page).to have_content "Sign Out"
	end

	it 'redirect student to the sign in page' do
		student = create :student
		visit '/students/dashboard'
		click_link "Sign Out"

		expect(current_url).to match '/'
	end

end