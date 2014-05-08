require 'spec_helper'

describe 'Twilio feature specs' do 

	context "On the index page, teachers can see that" do
		specify "their number is not set" do
			login_as (create :teacher)
			visit twilio_infos_path
			expect(page).to have_content 'Phone number: Not set'
		end

		specify "they do not have twillio alerts enabled" do
			login_as (create :teacher)
			visit twilio_infos_path
			expect(page).to have_content 'Twilio Alerts: Not set'
		end
	end

	context "On the create page, can" do
		before{
			login_as (create :teacher)
			visit twilio_infos_path
		}
		it 'add their telephone number' do 
			click_link 'Add Number'
			fill_in "twilio_info_phone_number", with: "+447879666184"
			click_button 'Update Twilio Info'
			expect(page).to have_content 'Phone number: +447879666184'
		end

		it 'try to create without a telephone number, but throws an error' do
			click_link 'Add Number'
			click_button 'Update Twilio Info'
			expect(page).to have_content "Phone number can't be blank"
		end

		it 'enable twilio' do 
			click_link 'Add Number'
			fill_in "twilio_info_phone_number", with: "+447879666184"
			check('twilio_info_enabled')
			click_button 'Update Twilio Info'
			expect(page).to have_content 'Twilio Alerts: true'
		end
	end

	context "On the edit page, can" do
		before{
			login_as (create :teacher, twilio_info: (create :twilio_info))
			visit twilio_infos_path
		}
		it 'add their telephone number' do 
			click_link 'Edit Number'
			fill_in "twilio_info_phone_number", with: "+447879666184"
			click_button 'Update Twilio Info'
			expect(page).to have_content 'Phone number: +447879666184'
		end

		it 'try to create without a telephone number, but throws an error' do
			click_link 'Edit Number'
			fill_in "twilio_info_phone_number", with: ""
			click_button 'Update Twilio Info'
			expect(page).to have_content "Phone number can't be blank"
		end

		it 'enable twilio' do 
			click_link 'Edit Number'
			fill_in "twilio_info_phone_number", with: "+447879666184"
			check('twilio_info_enabled')
			click_button 'Update Twilio Info'
			expect(page).to have_content 'Twilio Alerts: true'
		end
	end

	it "can delete their twilio information" do
		login_as (create :teacher, twilio_info: (create :twilio_info))
		visit twilio_infos_path
		click_link "Delete Number"
		expect(page).to have_content 'Phone number: Not set'
		expect(page).to have_content 'Twilio Alerts: Not set'
	end

end