require "spec_helper"

describe "Cohort Features" do

  context "Creating a cohort" do
    it "returns an error if not signed in as a teacher" do
      visit new_cohort_path
      expect(page).to have_content 'You need to sign in or sign up before continuing'
    end

    it "is successful if signed in as a teacher" do
      login_as create :teacher
      visit new_cohort_path
      select('January', :from => 'cohort_month')
      select('2020', :from => 'cohort_year')
      click_button 'Create Cohort'
      expect(page).to have_content "January 2020"
    end

    it "returns an error if already exists" do
      create :february
      login_as create :teacher
      visit new_cohort_path
      select('February', :from => 'cohort_month')
      select('2014', :from => 'cohort_year')
      click_button 'Create Cohort'
      expect(page).to have_content 'February 2014 has already been created!'
    end
  end

  context "Editing a cohort" do
    before{ create :january }
    specify "returns an error if not signed in as a teacher" do
      visit edit_cohort_path(Cohort.last.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing'
    end

    specify "is successful if signed in as a teacher" do
      login_as create :teacher
      visit edit_cohort_path(Cohort.last.id)
      select('February', :from => 'cohort_month')
      select('2014', :from => 'cohort_year')
      click_button "Update Cohort"
      expect(page).to have_content "February 2014"
    end
  end

  context "Deleting a cohort" do
    before{ create :january }
    specify "returns an error if not signed in as a teacher" do
      visit cohorts_path
      expect(page).to have_content 'You need to sign in or sign up before continuing'
    end

    specify "is successful if signed in as a teacher" do
      login_as create :teacher
      visit cohorts_path
      page.find(".table").click_link "Delete"
      expect(page).not_to have_content "January 2014"
    end
  end

  specify "can set current cohorts" do
    create :march
    create :april
    login_as create :teacher
    visit cohorts_path
    select("March 2014", from: 'cohort1_id')
    select("April 2014", from: 'cohort2_id')
    expect(page).to have_css '#cohort1_option', text: "March 2014"
    expect(page).to have_css '#cohort2_option', text: "April 2014"
  end
end