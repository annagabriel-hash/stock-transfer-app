class Buy < ApplicationRecord
  belongs_to :stock
  belongs_to :user
  has_many :trades, dependent: :destroy
  enum status: { open: 0, close: 1, cancelled: 2 }
  enum order_type: { market_order: 0, limit_order: 1 }
  scope :price_greater_than_equal, ->(price) { where('price >= ?', price).order(price: :desc, shares: :desc) }
  scope :shares_equal, ->(shares) { where(shares: shares).order(price: :desc, shares: :desc) }
  validates :order_type, presence: true
  validate :user_cannot_have_insufficient_balance, on: %i[create update]

  def amount
    price * shares
  end

  def matching_orders
    Sell.open.price_less_than_equal(price).shares_equal(shares)
  end

  def fulfill_order
    trades.create(stock: stock, price: price, shares: shares)
    close!
  end

  private

  def sufficient_balance?
    user.balance >= amount
  end

  def user_cannot_have_insufficient_balance
    errors.add(:amount, "can't be greater than the balance") unless sufficient_balance?
  end
end
