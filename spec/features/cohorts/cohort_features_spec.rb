require "spec_helper"

describe "Creating a cohort" do
  specify "returns an error if not signed in as a teacher" do
    visit new_cohort_path
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  specify "is successful if signed in as a teacher" do
    login_as create :teacher
    visit new_cohort_path
    select('January', :from => 'cohort_month')
    select('2020', :from => 'cohort_year')
    click_button 'Create Cohort'
    expect(page).to have_content "January 2020"
  end
end

describe "Editing a cohort" do
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

describe "Deleting a cohort" do
  before{ create :january }
  specify "returns an error if not signed in as a teacher" do
    visit cohorts_path
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  specify "is successful if signed in as a teacher" do
    login_as create :teacher
    visit cohorts_path
    click_link "Delete"
    expect(page).not_to have_content "January 2014"
  end
end