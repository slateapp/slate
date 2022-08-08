# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :twilio_info do
    phone_number { '+447879666184' }
    enabled { true }
  end
end
