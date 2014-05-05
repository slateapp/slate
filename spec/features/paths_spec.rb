require 'spec_helper'

describe 'redirects to dashboard' do 

	context 'when signed in as a student', js:true do
		let(:alex) { Student.find_by(email: 'alex@example.com') }
		before do
			sign_in_as_student_alex
      create(:request, student: alex, category: (create :category))
      visit '/students/dashboard'
		end

		it 'after signing in', js:true do
			expect(current_url).to match /dashboard/
			expect(current_url).to match /students/
		end

		it 'after deleting own request', js:true do
			click_link 'Delete'

			expect(current_url).to match /dashboard/
			expect(current_url).to match /students/
		end

		it 'after editing own request', js:true do
			click_link 'Edit'
			click_button 'Update'

			expect(current_url).to match /dashboard/
			expect(current_url).to match /students/
		end		
	end

	context 'when signed in as a teacher', js:true do
		let(:alex) { Student.find_by(email: 'alex@example.com') }
		before do 
			sign_in_as_student_alex
      create(:request, student: alex, category: (create :category))
      sign_out_as_student_alex
			login_as create :teacher
      visit dashboard_teachers_path
		end

		it 'after signing in', js:true do
			expect(current_url).to match /dashboard/
			expect(current_url).to match /teachers/
		end

		it 'after deleting a students request', js:true do
			click_link 'Delete'
			expect(current_url).to match /dashboard/
			expect(current_url).to match /teachers/
		end

		it 'after editing a students request', js:true do
			click_link 'Edit'
			click_button 'Update'

			expect(current_url).to match /dashboard/
			expect(current_url).to match /teachers/
		end

		it 'after solving a students request', js:true do
			click_link 'SOLVED'
			
			expect(current_url).to match /dashboard/
			expect(current_url).to match /teachers/
		end
	end
end

