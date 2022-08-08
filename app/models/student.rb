# frozen_string_literal: true

# Sudent model
class Student < ActiveRecord::Base
  include Gravtastic
  gravtastic secure: true, size: 55
  has_many :authorizations, dependent: :destroy
  has_many :requests
  belongs_to :cohort
  validates :email, presence: true
  before_save :set_name_if_blank

  def set_name_if_blank
    self.name = email if name.blank?
  end

  def approve
    self.approved = true
    save
  end

  def unapprove
    self.approved = false
    save
  end
end
