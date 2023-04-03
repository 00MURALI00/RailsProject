class Teacher < ApplicationRecord
    has_one :user, as: :accountable, dependent: :destroy
end
