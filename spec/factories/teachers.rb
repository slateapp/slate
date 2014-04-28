# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :teacher do
    email "evgeny@makersacademy.com"
    password "12345678"
    password_confirmation "12345678"
  end

  factory :not_teacher, class: Teacher do
    email "khushkaran@me.com"
    password "12345678"
    password_confirmation "12345678"
  end
end
