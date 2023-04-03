class Option < ApplicationRecord
  belongs_to :question
  validates :question, presence: true
  validates :opt1, :opt2, :opt3, :opt4, presence: true
end
