# frozen_string_literal: true

require 'spec_helper'

describe 'Category Features' do
  context 'Creating a category' do
    it 'returns an error if not a teacher is not signed in' do
      visit new_category_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    it 'is successful if a teacher is signed in' do
      login_as create :teacher
      visit new_category_path
      fill_in 'Category', with: 'Ruby'
      click_button 'Create Category'
      expect(page).to have_content 'Ruby'
    end

    it 'returns an error if category already exists' do
      create :category
      login_as create :teacher
      visit new_category_path
      fill_in 'Category', with: 'Ruby'
      click_button 'Create Category'
      expect(page).to have_content 'Name has already been taken'
    end
  end

  context 'Editing a category' do
    before { create :category }
    it 'returns an error if not a teacher is not signed in' do
      visit edit_category_path(Category.last.id)
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
    it 'is successful if a teacher is signed in' do
      login_as create :teacher
      visit edit_category_path(Category.last.id)
      fill_in 'Category', with: 'JavaScript'
      click_button 'Update Category'
      expect(page).to have_content 'JavaScript'
      expect(page).to have_content 'Category updated successfully'
    end
  end

  context 'Deleting a category' do
    before { create :category }
    it 'returns an error if not a teacher is not signed in' do
      visit categories_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
    it 'is successful if a teacher is signed in' do
      login_as create :teacher
      visit categories_path
      page.find('.table').click_link 'Delete'
      expect(page).not_to have_content 'Ruby'
      expect(page).to have_content 'Category deleted successfully'
    end
  end
end
