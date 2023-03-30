class Test < ApplicationRecord
    belongs_to :course
    has_many :questions, dependent: :destroy
    has_many :testresults, dependent: :destroy
end
