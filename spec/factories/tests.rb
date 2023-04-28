FactoryBot.define do
  factory :test do
    name { 'MyString' }
    published_at { '2023-04-12' }
    attempts { 5 }
    course
  end
end
