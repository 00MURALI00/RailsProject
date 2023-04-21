FactoryBot.define do
  factory :user do
    # name { 'Tester' }
    sequence :email do |n|
      "tester_#{n}@rently.com"
    end
    password { '1234567' }
    password_confirmation { '1234567' }

    for_students

    trait :for_students do
      association :accountable, factory: :student
	  role { 'student'}
    end

    trait :for_teachers do
      association :accountable, factory: :teacher
	  role {'teacher'}
    end
  end

#   factory :teachers do
#     name { 'John Doe' }
#     gender { 'Male' }
#     age { 30 }
#   end

#   factory :students do
#     name { 'Max' }
#     gender { 'Male' }
#     age { '20' }
#   end
end
