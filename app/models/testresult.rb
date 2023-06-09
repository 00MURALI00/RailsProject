# frozen_string_literal: true

class Testresult < ApplicationRecord
  belongs_to :test
  validates :score, presence: true
  validates :score, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  before_save :attempt_no

  def attempt_no
    testresult = Testresult.where('test_id = ? AND student_id = ?', test_id, student_id).count
    self.attempt_no = if !testresult.nil?
                        testresult + 1
                      else
                        1
                      end
  end
end
