FactoryBot.define do
  factory :product do
    association :contact
    name { "MyString" }
  end
end
