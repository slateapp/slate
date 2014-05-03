# require "spec_helper"

# describe "Whilst teacher signed in" do
#   context "whilst actioning a student" do
#     before(:each) do
#       create :february
#       login_as create :teacher
#       visit dashboard_teachers_path
#       create :khush
#       click_link "Students"
#       click_link "Awaiting approval"
#     end

#     it "can approve a student" do
#       click_link "Approve"
#       expect(page).to have_content "Khushkaran Singh Bajwa has been approved!"
#     end

#     it "can delete a student" do
#       click_link "Delete"
#       expect(page).to have_content "Khushkaran Singh Bajwa has been deleted!"
#     end

#     context "editing a student" do
#       before(:each) do
#         click_link "Approve"
#         click_link "Approved"
#         click_link "Edit"
#       end

#       it "can edit a student's cohort" do
#         select('February 2014', :from => 'cohort_id')
#         click_button "Update Student"
#         expect(page).to have_content "February 2014"
#         expect(page).not_to have_content "No cohort assigned"
#       end

#       it "can edit a student's name" do
#         fill_in "student_name", with: "Jack Whitehall"
#         click_button "Update Student"
#         expect(page).to have_content "Jack Whitehall"
#         expect(page).not_to have_content "Khushkaran Singh Bajwa"
#       end
#     end
#   end
# end