require 'spec_helper'

describe 'deleting' do
	it 'removes the request' do
		create(:request)

		visit '/requests'
		click_link 'Delete'

		expect(page).to have_content 'Request deleted'
	end
end
