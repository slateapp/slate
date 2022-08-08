# frozen_string_literal: true

json.cohorts @cohorts do |cohort|
  json.cohort_id cohort.id
  json.cohort_name cohort.name.split(' ').join('_').downcase
end
