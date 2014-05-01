require 'spec_helper'

describe 'Teacher solves a request' do

  context 'logged in as teacher' do
    let(:teacher) { create :teacher }
    before(:each) do
      create :february
      visit '/teachers/sign_in'
      fill_in "Email", with: teacher.email
      fill_in "Password", with: teacher.password
      click_button "Sign in"
    end

    it "should display the Dashboard after login" do
      expect(page).to have_content 'Welcome Evgeny'
    end

    xit 'should be click the solve button' do
    	visit '/requests'
    	

    	expect(page).to have_content 'Solve'
    end
	end
end