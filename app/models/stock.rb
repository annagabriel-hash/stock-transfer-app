class Stock < ApplicationRecord
  validates :ticker, presence: true
end
