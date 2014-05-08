# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :twilio_info do
  	phone_number "+447879666184"
  	enabled true
  end
end
