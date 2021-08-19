FactoryBot.define do
  factory :role do
    name { 'buyer' }
    initialize_with { Role.find_or_create_by(name: name) }
  end

  trait :admin do
    name { 'admin' }
  end

  trait :broker do
    name { 'broker' }
  end
end
