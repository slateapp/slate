require "spec_helper"

describe "Teacher Stat Features" do
  context 'On the dashboard, it displays' do
    before{
      login_as create :teacher
      @now = Time.now.beginning_of_minute
      ruby = create :category
      postgresql = create :postgresql
      create :request, {category: ruby, solved: true, created_at: @now - (60*5), solved_at: @now - (60*3)}
      create :request, {category: ruby, solved: true, created_at: @now - (60*4), solved_at: @now - (60*2)}
      create :request, {category: postgresql, solved: true, created_at: @now - (60*3), solved_at: @now - (60*1)}
      create :request, {category: postgresql, solved: true, created_at: @now - (60*3), solved_at: @now - (60*1)}
      create :request, {category: postgresql, solved: false, created_at: @now - (60*2)}
      create :request, {category: postgresql, solved: false, created_at: @now - (60*1)}
    }
    specify "today's average wait time" do
      visit dashboard_teachers_path
      expect(page).to have_content "Today's average wait time: 2 Minutes"
    end

    specify "today's average queue length" do
      visit dashboard_teachers_path
      expect(page).to have_content "Today's average queue length: 2 Students"
    end
  end
end