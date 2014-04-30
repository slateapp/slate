require 'spec_helper'


describe 'editing requests' do

	context 'signed in as Alex' do
		
		before do
			sign_in_as_student_alex
		end
		let(:alex) { Student.find_by(email: 'alex@example.com') }

		describe "attempting to edit Sarah's request" do

			xit 'displays error' do
				sarah = create(:sarah)
				create(:request, student: sarah)
				visit '/requests'
				click_link 'Edit'

				expect(page).to have_content 'Error'
			end
		end

		describe "attempting to edit own request" do

			xit 'edits the post' do
				create(:request, student: alex)
				visit '/requests'
				click_link 'Edit'

				expect(page).to have_content 'Request edited'
			end
		end
	end
end



