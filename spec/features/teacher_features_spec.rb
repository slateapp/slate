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
    visit '/teachers'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  context 'logged in as teacher' do
    it "should diplay the Dashboard" do
      login_as create :teacher
      visit '/teachers'
      expect(page).to have_content 'Welcome evgeny@makersacademy.com'
    end
  end
end