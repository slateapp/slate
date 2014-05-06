
# require 'spec_helper'

# describe 'Request board' do 

# 	before do 
# 		sign_in_as_student_alex
# 		visit students_dashboard_path
# 	end

# 	context 'No requests' do 
# 		it 'returns a blank board' do 
# 			expect(Request.board_empty?).to be_true
# 		end
# 	end

# 	context 'An unsolved request is created' do
# 		it 'returns a board with an unsolved request' do
# 			create_request

# 			expect(Request.board_empty?).to be_false
# 		end
# 	end

# 	context 'An solved request is created' do
# 		it 'returns a board with an unsolved request' do
# 			create_request

# 			expect(Request.board_empty?).to be_false
# 		end
# 	end
# end