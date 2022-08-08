# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :category do
    name { 'Ruby' }
  end

  factory :postgresql, class: Category do
    name { 'Postgresql' }
  end
end
