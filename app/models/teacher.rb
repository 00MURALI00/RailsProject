class Teacher < ApplicationRecord
  has_one :user, as: :accountable, dependent: :destroy
  has_many :courses, dependent: :destroy
  accepts_nested_attributes_for :user
  validates :name, presence: true
  validates :age, presence: true
  validates :gender, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0, less_than: 100}
end
