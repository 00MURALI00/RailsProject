# frozen_string_literal: true

class Note < ApplicationRecord
  belongs_to :course
  has_one_attached :file, dependent: :destroy
  validates :file, presence: true
end
