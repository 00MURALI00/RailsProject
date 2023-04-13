# frozen_string_literal: true

class Student < ApplicationRecord
  has_one :user, as: :accountable, dependent: :destroy
  has_and_belongs_to_many :courses, join_table: :courses_students
  has_many :tests, through: :courses
  has_many :testresults, through: :test
  has_many :notes, through: :courses

  scope :test_taken, lambda {
                       Student.where('id IN (?)', Array.wrap(Testresult.select(:student_id).pluck(:student_id)))
                     }
  scope :test_not_taken, lambda {
                           Student.where('id NOT IN (?)', Array.wrap(Testresult.select(:student_id).pluck(:student_id)))
                         }
  accepts_nested_attributes_for :user
  validates :name, presence: true
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
  validates :gender, presence: true
end
