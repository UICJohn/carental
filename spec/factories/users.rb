FactoryBot.define do
  factory :user, class: User do
    sequence(:email) { |n| "user#{n}@gmail.com" }
    username { 'john' }
    password { '1234567' }
  end
end
