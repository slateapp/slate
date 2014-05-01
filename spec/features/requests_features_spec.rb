require 'spec_helper'

describe 'requests page' do
	context 'no requests' do
		it 'shows a message' do
			visit '/requests'
			expect(page).to have_content 'No requests'
		end
	end

	describe 'adding requests' do
		it "throws an error if the user doesn't pick a category" do
			sign_in_as_student_alex
			visit '/requests/new'
		  fill_in 'Description', with: 'Migration issue'
		  click_button 'Create Request'
		  expect(page).to have_content 'Error: Please fill out all fields'
		end

		it "throws an error if the user doesn't enter a description" do
			sign_in_as_student_alex
			create :postgresql
			visit '/requests/new'
		  select('Postgresql', from: 'Category')
		  click_button 'Create Request'
		  expect(page).to have_content 'Error: Please fill out all fields'
		end

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

		context 'teacher tries to create request' do
			let(:teacher) { create :teacher }
			
			before {
				login_as teacher
				visit '/requests'
			}

			it 'should be unable to create request' do
				click_link 'Create request'

				expect(page).to have_content 'No'
			end

		end
	end
end
