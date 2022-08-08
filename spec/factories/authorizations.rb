# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :authorization do
    provider { 'MyString' }
    uid { 'MyString' }
  end
end
