require 'spec_helper'

describe 'redirects to dashboard' do 

	context 'when signed in as a student' do
		let(:alex) { Student.find_by(email: 'alex@example.com') }
		before do
			sign_in_as_student_alex
			create :category
      create(:request, student: alex, category: Category.last.id.to_s)
		end

		it 'after signing in' do

			expect(current_url).to match /dashboard/
			expect(current_url).to match /students/
		end

		it 'after deleting own request' do


			expect(current_url).to match /dashboard/
			expect(current_url).to match /students/
		end

		it 'after editing own request' do

			expect(current_url).to match /dashboard/
			expect(current_url).to match /students/
		end		
	end

	context 'when signed in as a teacher' do
		let(:alex) { Student.find_by(email: 'alex@example.com') }
		before do 
			sign_in_as_student_alex
			create :category
      create(:request, student: alex, category: Category.last.id.to_s)
      sign_out_as_student_alex
			login_as create :teacher
      visit dashboard_teachers_path
		end

		it 'after signing in' do
			expect(current_url).to match /dashboard/
			expect(current_url).to match /teachers/
		end

		it 'after deleting a students request' do
			click_button '{{ delete_url }}'

			expect(current_url).to match /dashboard/
			expect(current_url).to match /teachers/
		end

		it 'after editing a students request' do



			expect(current_url).to match /dashboard/
			expect(current_url).to match /teachers/
		end

		it 'after solving a students request', do
			click_link 'SOLVED'

			expect(current_url).to match /dashboard/
			expect(current_url).to match /teachers/
		end
	end
end

