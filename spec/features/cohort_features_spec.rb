require "spec_helper"

describe "Cohorts" do
  context 'not logged in as a teacher' do
    it 'returns an error' do
      visit '/cohorts/new'
      expect(page).to have_content 'You need to sign in or sign up before continuing'
    end
  end
  context 'logged in as a teacher' do
    before(:each) do
      login_as create :teacher
    end
    it "can be created by a teacher" do
      visit '/cohorts/new'
      fill_in "Cohort", with: "February"
      click_button 'Create Cohort'
      expect(Cohort.count).to eq 1
    end
  end
end