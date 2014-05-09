require 'spec_helper'

describe 'requests page' do

	# check repetition in requests_board_features_spec.rb
	context 'no requests' do
		it 'shows a message', js: true do
			visit '/requests'
			expect(page).not_to have_css 'div.waitingList div.waiting'
		end
	end

	describe 'adding requests' do
		it "throws an error if the user doesn't pick a category" do
			sign_in_as_student_alex
			visit '/students/dashboard'
		  fill_in 'Description', with: 'Migration issue'
		  click_button 'Create Request'
		  expect(page).to have_content "Category can't be blank"
		end

		it "throws an error if the user doesn't enter a description" do
			sign_in_as_student_alex
			create :postgresql
			visit '/students/dashboard'
		  select('Postgresql', from: 'Category')
		  click_button 'Create Request'
		  expect(page).to have_content "Description can't be blank"
		end

		context '1 valid post' do
			it 'displays one request', js: true do
				sign_in_as_student_alex
				create_request

				expect(current_path).to eq '/students/dashboard'
				expect(page).to have_content 'Your request has been created.'
			end
		end

		context 'with requests' do
	    before {
	    	sign_in_as_student_alex
	    	create_request
	    }

	    it 'displays the request', js: true do
	      visit '/requests'
				expect(page).to have_content 'Postgresql'
	    end

	    it 'displays the request time' do
	    	visit '/requests'
	    	expect(page).to have_content 'time'
	    end
		end

		context 'teacher tries to create request' do
			let(:teacher) { create :teacher }
			
			before {
				login_as teacher
			}

			it 'should be unable to create request' do
				visit '/requests'

				expect(page).not_to have_content 'Create request.'
			end

			it 'should be unable to see the Create button' do
				visit '/requests'

				expect(page).not_to	have_content 'Create request'
			end
		end
	end
end
