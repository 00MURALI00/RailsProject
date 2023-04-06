# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :course
  has_one_attached :file, dependent: :destroy
  has_event :publish
  scope :published, -> { where.not(published_at: nil) }
  scope :unpublished, -> { where(published_at: nil) }
end
