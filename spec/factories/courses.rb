FactoryBot.define do
  factory :course do
    name { 'MyString' }
    description { 'This is a valid description' }
    teacher
  end
end
