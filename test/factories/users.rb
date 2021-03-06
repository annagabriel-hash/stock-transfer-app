require 'faker'

FactoryBot.define do
  factory :user do
    first_name { 'John' }
    last_name { 'Doe' }
    email { 'johndoe@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    trait :buyer do
      roles { [association(:role)] }
    end

    trait :admin do
      email { 'admin@example.com' }
      roles { [association(:role, :admin)] }
    end

    trait :broker do
      roles { [association(:role), association(:role, :broker)] }
      status { 'approved' }
    end

    before(:create) { create(:role) }
  end

  factory :random_user, class: User do
    first_name { Faker::Name.first_name }
    email { Faker::Internet.safe_email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
