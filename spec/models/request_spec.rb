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

	context 'A solved request is created' do
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

	context 'The board has been empty for more than five minutes' do
		it 'knows the time between a solved and new request is greater than 5 minutes' do
			expect(Request.board_empty_for?(5)).to be_true
		end

		it 'knows the time between a solved and new request is less than 5 minutes' do
			expect(Request.board_empty_for?(4)).to be_false
		end

		it 'should subtract the time between a solved and new request' do 
			Request.last
		end
	end





end