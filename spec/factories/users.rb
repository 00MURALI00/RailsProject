FactoryBot.define do
  factory :user do
		name { "Tester" }
		sequence :email do |n|
			"tester_#{n}@rently.com"
		end
		password { "1234567" }
		password_confirmation { "1234567" }

		for_student_user

		trait :for_students do
			association :accountable, factory: :students
		end

		trait :for_teachers do
			association :accountable, factory: :teachers
		end

	end

	factory :teachers do
		name {"John Doe"}
    gender { "Male" }
    age { 30 }
	end

	factory :students do
		name {"Max"}
    gender {"Male"}
    age {"20"}
	end
end
