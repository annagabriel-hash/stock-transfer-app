class Offer < ApplicationRecord
  belongs_to :stock
  belongs_to :user
  enum status: { open: 0, close: 1, cancelled: 2 }
  enum type: { limit_order: 0, market_order: 1 }
  enum action: { buy: 0, sell: 1 }
  validates :type, presence: true
  validates :action, presence: true
end
