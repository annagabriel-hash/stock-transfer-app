FactoryBot.define do
  factory :sell do
    user
    stock
    price { 300 }
    shares { 10 }
    order_type { 0 }
  end
end
