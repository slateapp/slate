require 'spec_helper'

describe 'Solving a request' do

  context 'logged in as teacher' do
    let(:teacher) { create :teacher }
    let(:alex) { Student.find_by(email: 'alex@example.com') }


    before do
      sign_in_as_student_alex
      create(:request, student: alex, category: (create :category))
      sign_out_as_student_alex  
      login_as teacher
    end

    it 'should be able to see the SOLVED button', js:true do
    	visit '/requests'      
    	expect(page).to have_content 'SOLVED'
    end

    it 'should be able to click the SOLVED link', js:true do
      visit '/requests'
      click_link 'SOLVED'
      expect(page).not_to have_content 'hello'
      expect(page).to have_content 'Request was successfully updated'
    end
	end

  context 'logged in as student' do
    let(:alex) { Student.find_by(email: 'alex@example.com') }


    before do
      sign_in_as_student_alex
      create(:request, student: alex, category: (create :category))
    end

    it 'cannot click the SOLVED link', js:true do
      visit '/requests'

      expect(page).not_to have_link 'SOLVED'
    end
  end
end