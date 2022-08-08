# frozen_string_literal: true

require 'spec_helper'

describe 'Requests Display' do
  it 'should display the titles of the two current cohorts' do
    create :february, selected: true
    create :march, selected: true
    visit display_requests_path
    expect(page).to have_content 'February 2014'
    expect(page).to have_content 'March 2014'
  end
end
