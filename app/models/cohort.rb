# frozen_string_literal: true

# Cohort model
class Cohort < ActiveRecord::Base
  has_many :students
  validates :month, :year, presence: true
  validate :cohort_uniqueness
  scope :current_cohorts, -> { where(selected: true) }

  def cohort_uniqueness
    existing_record = Cohort.where(month: month, year: year).count
    errors.add("#{month} #{year}", 'has already been created!') if existing_record.positive?
  end

  def name
    "#{month} #{year}"
  end

  def name_to_date
    Date.parse(name)
  end
end
