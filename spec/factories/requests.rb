# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :request do
    description { 'hello' }
    solved { false }
    category
  end
end
