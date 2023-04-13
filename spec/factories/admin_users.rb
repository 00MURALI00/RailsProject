FactoryBot.define do
  factory :admin_user do
    id { 1 }
    email { "MyString" }
    encrypted_password { "MyString" }
    reset_password_token { "MyString" }
    reset_password_sent_at { "2023-04-12 11:38:07" }
    remember_created_at { "2023-04-12 11:38:07" }
    created_at { "2023-04-12 11:38:07" }
    updated_at { "2023-04-12 11:38:07" }
  end
end
