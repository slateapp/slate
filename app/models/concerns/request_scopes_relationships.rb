module RequestScopesRelationships
  def self.included(base)
    base.class_eval do
      request_relationships
      request_validations
      request_scopes
      request_actions
    end
  end
end

def request_relationships
  belongs_to :student
  belongs_to :category
  belongs_to :teacher
end

def request_validations
  validates :category, :description, :presence => true
  validate :time_creation
end

def request_scopes
  scope :todays_requests, ->(minute) { where(created_at: Time.now.beginning_of_day..minute) }
  scope :created_requests_count_for, ->(minute) { where(created_at: minute-1..minute).count }
  scope :solved_requests_count_for, ->(minute) { where(solved_at: minute-1..minute).count }
  scope :this_weeks_requests, -> {where(created_at: Date.today.beginning_of_week..Time.now)}
  scope :solved_by, ->(teacher) {where(teacher: teacher)}
  scope :categorised_by, ->(category) {where(category: category)}
  scope :for_cohort, ->(cohort) {where(student:Student.where(cohort: cohort))}
  scope :solved_requests, -> { where(solved: true) }
  scope :unsolved_requests, -> { where(solved: false) }
end

def request_actions
  after_save :trigger_teacher_message
end