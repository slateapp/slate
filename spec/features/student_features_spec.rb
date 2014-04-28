require 'spec_helper'

describe 'Student sign-up' do 
	context 'Navigating to Github' do 
		it 'has a sign-up button' do
			visit '/students/sign_up'

			expect(page).to_have content 'Sign-up with Github'

		end
	end	
			
	
end