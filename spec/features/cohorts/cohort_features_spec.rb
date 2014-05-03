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
      visit '/teachers/dashboard'
      click_link "Cohorts"
      click_link "Add Cohort"
      select('January', :from => 'cohort_month')
      select('2020', :from => 'cohort_year')
      click_button 'Create Cohort'
      expect(page).to have_content "January 2020"
    end

    context 'a cohort has been created' do
      before(:each) do
        create :january
        visit '/teachers/dashboard'
        click_link "Cohorts"
      end
      
      it "can be edited" do
        click_link "Edit"
        select('February', :from => 'cohort_month')
        select('2014', :from => 'cohort_year')
        click_button "Update Cohort"
        expect(page).to have_content "February 2014"
      end

      it "can be deleted" do
        click_link "Delete"
        expect(page).not_to have_content "January 2014"
      end
    end
  end
end