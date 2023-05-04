class Course < ApplicationRecord
  has_many :tests, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_and_belongs_to_many :students, join_table: :courses_students
  belongs_to :teacher
  validates :description, length: { minimum: 10, too_short: '%<count>s is too short for a course description' }
  has_one_attached :image, dependent: :destroy
  before_create :set_default_image

  def set_default_image
    return if image.attached?

    image.attach(io: File.open(Rails.root.join('Dummy_flag.jpg')), filename: 'Dummy_flag.jpg',
                 content_type: 'image/jpg')
  end
end
