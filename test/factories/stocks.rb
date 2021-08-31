FactoryBot.define do
  factory :stock do
    ticker { 'MSFT' }
    name { 'Microsoft Corp.' }
    price { 303.33 }
    closing_price { 303.59 }
    change { 3.87 }
    change_percent { 0.0129 }
  end
end
