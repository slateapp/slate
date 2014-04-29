# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    name "Alex Peattie"
    email "alex@example.com"
  end

  factory :khush, class: Student do
    name "Khushkaran Singh Bajwa"
    email "khushkaran@example.com"
    approved false
  end
end
