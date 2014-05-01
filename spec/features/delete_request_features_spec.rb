require 'spec_helper'


describe 'deleting requests' do

	context 'signed in as Alex' do
		
		before do
			sign_in_as_student_alex
			create :category
		end
		
		let(:alex) { Student.find_by(email: 'alex@example.com') }

		describe "attempting to delete Sarah's request" do

			it 'displays error' do
				sarah = create(:sarah)
				create(:request, student: sarah, category: Category.last.id.to_s)
				visit '/requests'

				expect(page).not_to have_link 'Delete'
			end
		end

		describe "attempting to delete own request" do

			it 'removes the post' do
				create(:request, student: alex, category: Category.last.id.to_s)
				visit '/requests'
				click_link 'Delete'

				expect(page).to have_content 'Request deleted'
				expect(page).not_to have_content 'hello'
			end
		end
	end

	context 'signed in as Teacher' do
	  let(:teacher) { create :teacher }

	  before(:each) do
	    create :february
	    visit '/teachers/sign_in'
	    fill_in "Email", with: teacher.email
	    fill_in "Password", with: teacher.password
	    click_button "Sign in"
	  end

		describe "deleting a student's request" do

		let(:alex) { Student.find_by(email: 'alex@example.com') }

			xit 'removes the post' do
				create(:request, student: alex)
				visit '/requests'
				click_link 'Delete'

				expect(page).to have_content 'Request deleted'
				expect(page).not_to have_content 'hello'
			end
		end
	end
end



