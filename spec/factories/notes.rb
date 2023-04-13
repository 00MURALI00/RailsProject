FactoryBot.define do
  factory :note do
    name { "MyString" }
    description { "valid description" }
    published_at { "2023-04-12" }
    course
  end
end
