FactoryBot.define do
  factory :user_stock do
    user
    stock
    shares { 20_000 }
  end
end
