class Student < ApplicationRecord
  has_one :user, as: :accountable, dependent: :destroy

  scope :test_taken, lambda {
                       Student.where('id IN (?)', Array.wrap(Testresult.select(:student_id).pluck(:student_id)))
                     }
  scope :test_not_taken, lambda {
                           Student.where('id NOT IN (?)', Array.wrap(Testresult.select(:student_id).pluck(:student_id)))
                         }
end
