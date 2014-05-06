require 'spec_helper'

describe 'Request board' do 

	context 'No requests' do 
		it 'returns a blank board' do 
			expect(Request.board_empty?).to be_true
		end
	end

	context 'An unsolved request is created' do
		before do
			create(:request)
		end
		
		it 'returns a board with an unsolved request' do
			expect(Request.board_empty?).to be_false
		end
	end

	context 'An unsolved request is created' do
		before do
			create(:request, solved: true)
		end
		
		it 'returns a board with an unsolved request' do
			expect(Request.board_empty?).to be_true
		end
	end

	context 'A mixture of solved and unsolved requests' do
		before do
			create(:request, category: create(:postgresql))
			create(:request, solved: true)
		end
		
		it 'returns a board with an unsolved request' do
			expect(Request.board_empty?).to be_false
		end
	end
end