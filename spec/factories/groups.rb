FactoryBot.define do
  factory :group do
    name { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 50) }
    association :owner, factory: :user
  end
end