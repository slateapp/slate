require 'spec_helper'

describe 'Teacher solves a request' do

  context 'logged in as teacher' do
    let(:teacher) { create :teacher }
    let(:alex) { Student.find_by(email: 'alex@example.com') }


    before do
      sign_in_as_student_alex
      create :category
      create(:request, student: alex, category: Category.last.id.to_s)
      sign_out_as_student_alex  
      login_as teacher
    end

    it 'should be able to find the SOLVED button', js:true do
    	visit '/requests'
    	
    	expect(page).to have_content 'SOLVED'
    end
	end
end