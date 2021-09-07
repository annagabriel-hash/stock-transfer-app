class Sell < ApplicationRecord
  belongs_to :stock
  belongs_to :user
  has_many :trades, dependent: :destroy
  enum status: { open: 0, close: 1, cancelled: 2 }
  enum order_type: { market_order: 0, limit_order: 1 }
  scope :price_less_than_equal, ->(price) { where('price <= ?', price).order(price: :asc, shares: :desc) }
  scope :shares_equal, ->(shares) { where(shares: shares).order(price: :desc, shares: :desc) }
  validates :order_type, presence: true
  validate :user_cannot_have_insufficient_shares, on: %i[create update]

  def amount
    price * shares
  end

  def matching_orders
    Buy.open.price_greater_than_equal(price).shares_equal(shares)
  end

  def fulfill_order
    buy_order = matching_orders.first
    return if buy_order.blank?

    trades.create(stock: stock, price: price, shares: shares, buy: buy_order)
  end

  def sufficient_shares?
    user.shares(stock) >= shares
  end

  def user_cannot_have_insufficient_shares
    errors.add(:shares, "can't be greater than owned shares") unless sufficient_shares?
  end
end
