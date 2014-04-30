# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ross, class: Student do
    name "Ross Hepburn"
    email "ross@example.com"
  end

  factory :khush, class: Student do
    name "Khushkaran Singh Bajwa"
    email "khushkaran@example.com"
    approved false
  end
end
