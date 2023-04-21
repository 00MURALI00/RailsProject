# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :course
  has_one_attached :file, dependent: :destroy
  has_event :publish
  validates :name, presence: true
  validates :description, length: { minimum: 10, too_short: '%<count>s is too short for a course description' }
  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }
end
