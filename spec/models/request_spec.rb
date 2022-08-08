# frozen_string_literal: true

require 'spec_helper'

describe 'Request Timing Features' do
  let(:t) { Date.today }
  context 'creating a request between 08:30 and 22:00' do
    it 'is successful at 6:00' do
      time_now = Time.zone.local(t.year, t.month, t.day, 6, 0o0)
      Time.stub(:now).and_return(time_now)
      create :request
      expect(Request.count).to eq 1
    end

    it 'is successful at 22:00' do
      time_now = Time.zone.local(t.year, t.month, t.day, 22, 0o0)
      Time.stub(:now).and_return(time_now)
      create :request
      expect(Request.count).to eq 1
    end
  end

  context 'creating a request between 22:00 and 06:00' do
    it 'returns an error at 8:29' do
      time_now = Time.zone.local(t.year, t.month, t.day, 5, 59)
      Time.stub(:now).and_return(time_now)
      expect { create :request }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Request.count).to eq 0
    end

    it 'returns an error at 22:01' do
      time_now = Time.zone.local(t.year, t.month, t.day, 22, 0o1)
      Time.stub(:now).and_return(time_now)
      expect { create :request }.to raise_error(ActiveRecord::RecordInvalid)
      expect(Request.count).to eq 0
    end
  end
end

describe 'Request board' do
  include SmsSpec::Helpers

  context 'No requests' do
    it 'returns a blank board' do
      create :request
      expect(Request.board_empty?).to be_true
    end
  end

  context 'An unsolved request is created' do
    before do
      create :request
    end

    it 'returns a board with an unsolved request' do
      expect(Request.board_empty?).to be_true
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
      expect(Request.board_empty?).to be_true
    end
  end

  context 'The board has been empty for more than five minutes' do
    let(:ruby) { create :category }

    before do
      @now = Time.now.beginning_of_minute
      create :postgresql
      create :request, { category: ruby, solved: true, created_at: @now - 10.minutes, solved_at: @now - 5.minutes }
    end

    it 'knows the time between a solved and new request is greater than 5 minutes' do
      expect(Request.board_empty_for?(5.minutes)).to be_true
    end

    it 'subtracts the time between a solved and new request' do
      expect(Request.board_empty_for?(5.minutes)).to be_true
    end
  end

  context 'Board sends a teacher a text reminder' do
    let(:ruby) { create :category }
    let(:feb) { create :february }
    let(:twilio_info) { create :twilio_info, { enabled: true } }
    let!(:teacher) { create :teacher, cohort: feb, twilio_info: twilio_info }

    let(:request) { build :request, { category: ruby, solved: false, student: create(:student, cohort: feb) } }

    it 'creates a message' do
      expect(request.sms_text_body).to eq "There's a new request on the board, from Alex Peattie about Ruby."
    end

    it 'sends an SMS message' do
      Request.stub(:board_empty_for?).and_return(true)
      environment = double :env, production?: true
      Rails.stub(:env).and_return(environment)
      expect(request).to receive(:send_message)
      request.save
    end
  end
end
