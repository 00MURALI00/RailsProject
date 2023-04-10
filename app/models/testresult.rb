# frozen_string_literal: true

class Testresult < ApplicationRecord
  belongs_to :test
  validates :test, presence: true
end