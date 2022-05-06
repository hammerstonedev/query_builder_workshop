FactoryBot.define do
  factory :contact do
    association :team
    email { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
  end
end
