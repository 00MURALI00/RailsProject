# frozen_string_literal: true

class Testresult < ApplicationRecord
  belongs_to :test
  validates :score, presence: true
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end