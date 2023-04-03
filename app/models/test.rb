class Test < ApplicationRecord
  belongs_to :course
  validates :course, presence: true
  has_many :questions, dependent: :destroy
  has_many :testresults, dependent: :destroy
end
