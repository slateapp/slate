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
      visit '/teachers'
      click_link "Cohorts"
      click_link "Add Cohort"
      fill_in "Cohort", with: "kdnsflnflksdfnf"
      click_button 'Create Cohort'
      expect(page).to have_content "kdnsflnflksdfnf"
    end

    it "can be edited by a teacher" do
      create :january
      visit '/teachers'
      click_link "Cohorts"
      click_link "Edit"
      fill_in "Cohort", with: "February 2014"
      click_button "Update Cohort"
      expect(page).to have_content "February 2014"
    end
  end
end