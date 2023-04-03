class Question < ApplicationRecord
  belongs_to :test
  has_one :option, dependent: :destroy
  has_one :answer, dependent: :destroy

  accepts_nested_attributes_for :option, :answer
end
