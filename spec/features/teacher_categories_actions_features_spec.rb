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
end