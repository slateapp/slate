require 'spec_helper'

describe 'requests page' do
	context 'no requests' do
		it 'shows a message' do
			visit '/requests'
			expect(page).to have_content 'No requests'
		end
	end

	describe 'adding requests' do
		context '1 valid post' do
			it 'displays one request' do
				sign_in_as_student_alex
				create_request

				expect(current_path).to eq '/requests'
				expect(page).to have_content 'Migration issue'
				expect(page).to have_content 'Postgresql'
			end
		end

		context 'with requests' do
		    before {
		    	sign_in_as_student_alex
		    	create_request
		    }

		    it 'displays the request' do
		      visit '/requests'
		      expect(page).to have_content 'Migration issue'
					expect(page).to have_content 'Postgresql'
		    end

		    xit 'displays the request time' do
		    	visit '/requests'
		    	expect(page).to have_content Time.strftime( '%l:%M%p %e/%m' )
		    end
		end
	end
end
