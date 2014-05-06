require 'spec_helper'

describe 'Request board' do 

	context 'No requests' do 
	
		it 'returns a blank board' do 
			sign_in_as_student_alex
			visit students_dashboard_path

			expect(Request.blank_board?).to be_true
		end
	end
end