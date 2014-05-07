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
			create(:request, solved: true, solved_at: 10.minutes.ago)
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
			expect(Request.board_empty_for?(5.minutes)).to be_true
		end

		it 'subtracts the time between a solved and new request' do
			Request.last.solved_at.to_i - Request.create.created_at.to_i

			expect(Request.board_empty_for?(5.minutes)).to be_true
		end

	end

	context 'Board sends a teacher a text reminder' do
		let(:ruby) {create :category}
		let(:request) {build :request, {
			category: ruby, solved: false}}
		
		it 'creates a message' do
			expect(request.sms_text_body).to eq 'Teacher you have a new request'
		end

		it 'sends an SMS message' do
			expect(request).to receive(:send_message)
			request.save
		end
	end

	context 'Board sends texts to designated teachers' do
		let(:ruby) {create :category}
		let(:request) {build :request, {
			category: ruby, solved: false}}

		xit "connects a student's cohort to the corresponding teacher" do
			expect(match_cohort).to be_true
		end
	end
end