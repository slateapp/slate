require "spec_helper"

describe "Teacher Student Features" do
  context 'Whilst teacher signed in they' do
    before{
      create :february
      create :khush
      login_as create :teacher
      visit students_teachers_path
    }

    it "can approve a student" do
      click_link "Approve"
      expect(page).to have_content "Khushkaran Singh Bajwa has been approved!"
    end

    it "can delete a student" do
      click_link "Delete"
      expect(page).to have_content "Khushkaran Singh Bajwa has been deleted!"
    end

    context "can edit a student's" do
      before do
        click_link "Approve"
        click_link "Approved"
        click_link "Edit"
      end

      specify "name" do
        fill_in "student_name", with: "Jack Whitehall"
        click_button "Update Student"
        expect(page).to have_content "Jack Whitehall"
        expect(page).not_to have_content "Khushkaran Singh Bajwa"
      end

      specify "cohort" do
        select('February 2014', from: 'cohort_id')
        click_button "Update Student"
        expect(page).to have_content "February 2014"
        expect(page).not_to have_content "No cohort assigned"
      end
    end
  end
end