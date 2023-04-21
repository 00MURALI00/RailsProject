class Test < ApplicationRecord
  belongs_to :course
  validates :name, presence: true, length: { maximum: 50 }
  validates :attempts, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  has_many :questions, dependent: :destroy
  has_many :testresults, dependent: :destroy
  has_event :publish
  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }
end
