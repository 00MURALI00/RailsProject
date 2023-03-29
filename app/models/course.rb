class Course < ApplicationRecord
    has_many :tests, dependent: :destroy
    has_many :notes, dependent: :destroy
end
