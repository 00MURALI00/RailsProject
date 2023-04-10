class Teacher < ApplicationRecord
  has_one :user, as: :accountable, dependent: :destroy
  accepts_nested_attributes_for :user
end
