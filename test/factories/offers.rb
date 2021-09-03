FactoryBot.define do
  factory :offer do
    user
    stock
    price { 303.33 }
    shares { 1000 }
    type { 1 }
    action { 0 }
  end
end
