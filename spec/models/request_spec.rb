require 'spec_helper'

describe 'Request board' do 
	include SmsSpec::Helpers

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
     let(:ruby) {create :category}
     		
		before do
			@now = Time.now.beginning_of_minute
      postgresql = create :postgresql
      create :request, {category: ruby, solved: true, created_at: @now - 10.minutes, solved_at: @now - 5.minutes}
		end

		it 'knows the time between a solved and new request is greater than 5 minutes' do
			expect(Request.board_empty_for?(5)).to be_true
		end

		it 'subtracts the time between a solved and new request' do
			Request.last.solved_at.to_i - Request.create.created_at.to_i

			expect(Request.board_empty_for?(5)).to be_true
		end

	end

	context 'Sends teachers an SMS' do
		let(:request) {request = Request.create}
		it 'creates a message' do
			expect(request.sms_message).to eq 'This is a test message'
		end
	end

end