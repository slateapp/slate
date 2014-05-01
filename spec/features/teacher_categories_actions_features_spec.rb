require "spec_helper"

describe "Whilst teacher is signed in" do
	before(:each) do
    login_as create :teacher
    visit dashboard_teachers_path
  end
  specify 'they can create a category' do
    click_link "Categories"
    click_link "Add Category"
    fill_in "Category", with: "Ruby"
    click_button "Create Category"
    expect(page).to have_content "Ruby"
  end

  specify 'they can edit a category' do
    create :category
    click_link "Categories"
    click_link "Edit"
    fill_in "Category", with: "JavaScript"
    click_button "Update Category"
    expect(page).to have_content "JavaScript"
    expect(page).to have_content "Category updated successfully"
  end

  specify 'they can delete a category' do
    create :category
    click_link "Categories"
    click_link "Delete"
    expect(page).not_to have_content "Ruby"
    expect(page).to have_content "Category deleted successfully"
  end
end