FactoryBot.define do
  factory :trade do
    stock
    buy
    price { buy.price }
    shares { buy.shares }
  end
end
