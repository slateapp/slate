# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :teacher do
    email { 'evgeny@makersacademy.com' }
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Time.now }
  end

  factory :not_teacher, class: Teacher do
    email { 'khushkaran@me.com' }
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
