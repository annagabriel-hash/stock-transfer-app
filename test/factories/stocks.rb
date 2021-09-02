FactoryBot.define do
  factory :stock do
    ticker { 'MSFT' }
    name { 'Microsoft Corp.' }
    market_price { 303.33 }
  end
end
