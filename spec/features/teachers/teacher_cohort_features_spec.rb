# frozen_string_literal: true

require 'spec_helper'

describe 'Teacher Cohort Features' do
  context 'Viewing cohorts' do
    before do
      create(:ross, cohort: (create :march))
      create(:sarah, cohort: (create :april))
      login_as create :teacher
      visit dashboard_teachers_path
    end

    specify 'if no default set, will display prompt' do
      expect(page).to have_content 'Please set a default cohort'
    end

    specify 'if default set displays the cohort title' do
      visit cohorts_path
      select('March 2014', from: 'cohort_id')
      click_button 'Set as default'
      visit dashboard_teachers_path
      expect(page).to have_content 'March 2014'
      expect(page).to have_content 'Ross'
    end

    specify 'able to see all cohorts', js: true do
      select('March 2014', from: 'cohort_id')
      expect(page).to have_content 'Ross'
      select('April 2014', from: 'cohort_id')
      expect(page).to have_content 'Sarah'
    end
  end
end
