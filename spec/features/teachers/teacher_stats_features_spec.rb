require "spec_helper"

describe "Teacher Stat Features" do
  context 'On the dashboard, it displays' do
    before{
      teacher = create :teacher
      february = create :february
      sarah = create :sarah, {cohort: february}
      ross = create :ross, {cohort: february}
      login_as teacher
      ruby = create :category
      postgresql = create :postgresql
      create :request, {description: "Argh!", category_id: ruby.id,       solved: true,  created_at: Time.now-20.minutes, solved_at: Time.now-17.minutes, teacher_id: teacher.id, student_id: sarah.id}
      create :request, {description: "Argh!", category_id: postgresql.id, solved: true,  created_at: Time.now-17.minutes, solved_at: Time.now-12.minutes, teacher_id: teacher.id, student_id: sarah.id}
      create :request, {description: "Argh!", category_id: ruby.id,       solved: true,  created_at: Time.now-15.minutes, solved_at: Time.now-10.minutes, teacher_id: teacher.id, student_id: ross.id}
      create :request, {description: "Argh!", category_id: postgresql.id, solved: true,  created_at: Time.now-12.minutes, solved_at: Time.now-5.minutes, teacher_id: teacher.id, student_id: ross.id}
      create :request, {description: "Argh!", category_id: postgresql.id, solved: false, created_at: Time.now-10.minutes, student_id: sarah.id}
      create :request, {description: "Argh!", category_id: postgresql.id, solved: false, created_at: Time.now-5.minutes, student_id: ross.id}
    }
    specify "today's average wait time" do
      visit dashboard_teachers_path
      expect(page).to have_content "Today's average wait time 5 Minutes"
    end

    specify "today's average queue length" do
      visit dashboard_teachers_path
      expect(page).to have_content "Today's average queue length 1 Student"
    end
  end
end