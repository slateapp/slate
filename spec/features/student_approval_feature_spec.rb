require "spec_helper"

describe "An approved student" do
  it "is allowed to access their dashboard" do
    sign_in_as_student_alex
    expect(page).not_to have_content 'Error: you are still awaiting approval'
  end
end

describe "An unapproved student" do
  before(:each) do
    create :february
    sign_in_as_unapproved_student
    select('February 2014', :from => 'cohort_id')
    click_button "Submit"
  end
  
  it "is redirected with an error if they access their dashboard" do
    expect(page).to have_content 'Approval Required'
  end

  it "is redirected with an error if they try to make a new request" do
    visit '/requests/new'
    expect(page).to have_content 'Error: you are still awaiting approval'
  end
end