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
    before(:create) { create(:role) }
    before(:create) { create(:role, :broker) }
    before(:create) { create(:role, :admin) }
  end

  factory :random_user, class: User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
