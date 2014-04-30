require 'spec_helper'


describe 'deleting requests' do

	context 'signed in as Alex' do
		
		before do
			sign_in_as_student_alex
		end

		describe "attempting to delete Sarah's request" do

			xit 'displays error' do
				sarah = create(:sarah)
				create(:request, student: sarah)
				visit '/requests'
				click_link 'Delete'

				expect(page).to have_content 'Error'
			end
		end

		describe "attempting to delete own request" do

			it 'removes the post' do
				alex = create(:student)
				create(:request, student: alex)
				visit '/requests'
				click_link 'Delete'

				expect(page).to have_content 'Request deleted'
				expect(page).not_to have_content 'hello'
			end
		end
	end

	# context 'signed out' do
	# 	before { create (:request) }

	# 	describe 'someone attempting to delete a request' do
	# 		it 'tells you to sign in' do

	# 			visit '/dashboard'
	# 			click_link 'Delete'

	# 			expect(page).to have_content 'Sign in'
	# 		end
	# 	end
	# end
end


# describe 'deleting requests' do
# 	it 'removes the request' do
# 		# create(:request)
# 		sign_in_as_student_alex
# 		create_request
# 		click_link 'Delete'

# 		expect(page).to have_content 'Request deleted'
# 	end
# end

# 	describe 'attempting to delete posts' do 
# 		before { create(:request)} 
# 		xit 'not logged in' do
# 			visit '/requests'
# 			click_link 'Delete'

# 			expect(page).to have_content 'Sign in'
# 		end

		
# 	end

