require 'spec_helper'


describe 'deleting requests' do

	context 'signed in as Alex' do
		
		before do
			sign_in_as_student_alex
		end
		let(:alex) { Student.find_by(email: 'alex@example.com') }

		describe "attempting to delete Sarah's request" do

			it 'displays error' do
				sarah = create(:sarah)
				create(:request, student: sarah)
				visit '/requests'
				click_link 'Delete'

				expect(page).to have_content 'Error'
			end
		end

		describe "attempting to delete own request" do

			it 'removes the post' do
				create(:request, student: alex)
				visit '/requests'
				click_link 'Delete'

				expect(page).to have_content 'Request deleted'
				expect(page).not_to have_content 'hello'
			end
		end
	end
end



