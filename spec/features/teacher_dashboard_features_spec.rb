require "spec_helper"

describe "Teacher Dashboard" do
  specify 'should return an error not logged in as a teacher' do
    visit '/teachers/dashboard'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

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

    specify "able to see all cohorts", js: true do
      create(:ross, cohort: (create :march))
      create(:sarah, cohort: (create :april))
      visit dashboard_teachers_path
      select('March 2014', :from => 'cohort_id')
      expect(page).to have_content "Ross"
      select('April 2014', :from => 'cohort_id')
      expect(page).to have_content "Sarah"
    end

    context 'displays default cohort' do
      specify "no default specified prompts to create default" do
        expect(page).to have_content 'Please set a default cohort'
      end

      specify "default specified displays the cohort title" do
        visit cohorts_path
        select('February 2014', :from => 'cohort_id')
        click_button 'Set as default'
        visit dashboard_teachers_path
        expect(page).to have_content 'February 2014'
      end
    end
  end
end