# frozen_string_literal: true

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :january, class: Cohort do
    month { 'January' }
    year { '2014' }
  end

  factory :february, class: Cohort do
    month { 'February' }
    year { '2014' }
  end

  factory :march, class: Cohort do
    month { 'March' }
    year { '2014' }
  end

  factory :april, class: Cohort do
    month { 'April' }
    year { '2014' }
  end
end
