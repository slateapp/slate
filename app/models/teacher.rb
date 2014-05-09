class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :requests
  has_one :twilio_info
  scope :sms_enabled?, -> {  }

  def name
    self.email.gsub("@makersacademy.com", "").capitalize
  end

  def sms_enabled?
    twilio_info.enabled?
  end

  def phone_number
    twilio_info.phone_number
  end
end
