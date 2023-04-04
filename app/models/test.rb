class Test < ApplicationRecord
  belongs_to :course
  validates :course, presence: true
  has_many :questions, dependent: :destroy
  has_many :testresults, dependent: :destroy
  has_event :publish
  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }
end
