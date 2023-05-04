class Course < ApplicationRecord
  has_many :tests, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_and_belongs_to_many :students, join_table: :courses_students
  belongs_to :teacher
  validates :description, length: { minimum: 10, too_short: '%<count>s is too short for a course description' }
  has_one_attached :image, dependent: :destroy
end
