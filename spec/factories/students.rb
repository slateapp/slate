# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :student do
    name { 'Alex Peattie' }
    email { 'alex@example.com' }
  end

  factory :sarah, class: Student do
    name { 'Sarah C Young' }
    email { 'sarah@example.com' }
    approved { true }
    cohort { Cohort.find_by(month: 'February') }
  end

  factory :khush, class: Student do
    name { 'Khushkaran Singh Bajwa' }
    email { 'khushkaran@example.com' }
    approved { false }
  end

  factory :ross, class: Student do
    name { 'Ross' }
    email { 'ross@example.com' }
    approved { true }
  end
end
