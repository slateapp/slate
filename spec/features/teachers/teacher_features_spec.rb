# frozen_string_literal: true

require 'spec_helper'

describe 'Teacher Features' do
  context 'Sign up' do
    it 'returns an error if using a makersacademy email' do
      teacher = build :teacher
      visit new_teacher_registration_path
      fill_in 'Email', with: teacher.email
      fill_in 'Password', with: teacher.password
      fill_in 'Password confirmation', with: teacher.password_confirmation
      click_button 'Sign up'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.'
    end

    it 'is successful if using a non-makersacademy email' do
      teacher = build :not_teacher
      visit new_teacher_registration_path
      fill_in 'Email', with: teacher.email
      fill_in 'Password', with: teacher.password
      fill_in 'Password confirmation', with: teacher.password_confirmation
      click_button 'Sign up'
      expect(page).to have_content 'Sign up 1 error prohibited this teacher from being saved: Email is invalid'
    end
  end

  context 'Accessing the dashboard' do
    specify 'returns an error if not signed in as a teacher' do
      visit dashboard_teachers_path
      expect(page).to have_content 'You need to sign in or sign up before continuing'
    end

    specify 'is successful if signed in as a teacher' do
      create :february
      login_as create :teacher
      visit dashboard_teachers_path
      expect(page).to have_content 'Welcome Evgeny'
    end
  end
end
