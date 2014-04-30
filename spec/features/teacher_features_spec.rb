require 'spec_helper'

describe "Teacher signing up" do
  context 'validates email' do
    it "can sign up with @makersacademy.com domain" do
      teacher = build :teacher
      visit '/teachers/sign_up'
      fill_in "Email", with: teacher.email
      fill_in "Password", with: teacher.password
      fill_in "Password confirmation", with: teacher.password_confirmation
      click_button "Sign up"
      expect(page).to have_content "Welcome! You have signed up successfully."
    end

    it "cannot sign up with any other domain" do
      teacher = build :not_teacher
      visit '/teachers/sign_up'
      fill_in "Email", with: teacher.email
      fill_in "Password", with: teacher.password
      fill_in "Password confirmation", with: teacher.password_confirmation
      click_button "Sign up"
      expect(page).to have_content "Sign up 1 error prohibited this teacher from being saved: Email is invalid"
    end
  end
end

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
        select('February 2014', :from => 'cohort_id')
        click_button 'Set as default'
        visit dashboard_teachers_path
        expect(page).to have_content 'February 2014'
      end
    end

    context "whilst actioning a student" do
      before(:each) do
        create :khush
        click_link "Students"
        click_link "Awaiting approval"
      end

      it "can approve a student" do
        click_link "Approve"
        expect(page).to have_content "Khushkaran Singh Bajwa has been approved!"
      end

      it "can delete a student" do
        click_link "Delete"
        expect(page).to have_content "Khushkaran Singh Bajwa has been deleted!"
      end

      context "editing a student" do
        before(:each) do
          click_link "Approve"
          click_link "Approved"
          click_link "Edit"
        end

        it "can edit a student's cohort" do
          select('February 2014', :from => 'cohort_id')
          click_button "Update Student"
          expect(page).to have_content "February 2014"
          expect(page).not_to have_content "No cohort assigned"
        end

        it "can edit a student's name" do
          fill_in "student_name", with: "Jack Whitehall"
          click_button "Update Student"
          expect(page).to have_content "Jack Whitehall"
          expect(page).not_to have_content "Khushkaran Singh Bajwa"
        end
      end
    end
  end
end