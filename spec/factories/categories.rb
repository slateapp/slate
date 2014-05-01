# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    name "Ruby"
  end

  factory :postgresql, class: Category do
    name "Postgresql"
  end
end
