require 'spec_helper'

describe 'Student login with Github' do 
	context 'Navigating to Github' do 
		it 'has a login button' do
			visit '/students/login'

			expect(page).to have_content 'Login with Github'
		end

		
	end	
				
	
end