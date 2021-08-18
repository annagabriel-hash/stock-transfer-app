FactoryBot.define do
  factory :role do
    name { 'buyer' }

    trait :admin do
      name { 'admin' }
    end

    trait :broker do
      name { 'broker' }
    end
  end
end
