# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :january, class: Cohort do
    name "January 2014"
  end

  factory :february, class: Cohort do
  	name "February 2014"
  end
end
