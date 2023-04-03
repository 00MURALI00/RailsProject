class Course < ApplicationRecord
  has_many :tests, dependent: :destroy
  has_many :notes, dependent: :destroy
  validates :description, length: { minimum: 20, too_short: '%<count>s is too short for a course description' }
end
