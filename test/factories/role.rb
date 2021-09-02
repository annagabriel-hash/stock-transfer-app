FactoryBot.define do
  factory :role do
    name { 'buyer' }
    initialize_with { Role.find_or_create_by(name: name) }
  end

  trait :admin do
    name { 'admin' }
    initialize_with { Role.find_or_create_by(name: name) }
  end

  trait :broker do
    name { 'broker' }
    initialize_with { Role.find_or_create_by(name: name) }
  end
end
