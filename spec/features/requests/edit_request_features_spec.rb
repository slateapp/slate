# frozen_string_literal: true

require 'spec_helper'

describe 'editing requests' do
  before(:each) do
    create :category
  end

  it 'edits the request', js: true do
    sign_in_as_student_alex
    create_request

    visit students_dashboard_path
    sleep 1

    click_link 'Edit'

    fill_in 'Description', with: 'Migration issue'
    select('Ruby', from: 'Category')
    click_button 'Update'

    expect(current_path).to eq students_dashboard_path
    expect(page).to have_content 'Request was successfully updated.'
  end

  context 'signed in as Alex' do
    before do
      sarah = create(:sarah)
      create(:request, student: sarah, category: Category.last)
      sign_in_as_student_alex
    end

    let(:alex) { Student.find_by(email: 'alex@example.com') }

    describe "attempting to edit Sarah's request" do
      it 'displays error', js: true do
        #  puts page.html
        # visit '/'
        #  puts page.html

        # visit students_dashboard_path

        expect(page).not_to have_link 'Edit'
      end
    end

    describe 'attempting to edit own request' do
      it 'edits the post', js: true do
        create(:request, student: alex, category: Category.last)
        visit students_dashboard_path
        click_link 'Edit'
        fill_in 'Description', with: 'Edited issue'
        click_button 'Update'
        expect(page).to have_content 'Request was successfully updated.'
      end
    end
  end
end
