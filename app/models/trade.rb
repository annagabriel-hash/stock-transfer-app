class Trade < ApplicationRecord
  belongs_to :buy
  belongs_to :sell, optional: true
  belongs_to :stock
  validates :shares, presence: true
  validates :price, presence: true
  after_create :update_buyer_stock

  def amount
    price * shares
  end

  def buyer
    buy.user
  end

  def new_balance
    prev_balance = buyer.balance
    prev_balance - amount
  end

  private

  def update_buyer_stock
    buyer_stock = UserStock.where(user: buyer, stock: stock).first
    if buyer_stock.present?
      total_shares = buyer_stock.shares + shares
      buyer_stock.update(shares: total_shares)
    else
      UserStock.create(user: buyer, stock: stock, shares: shares)
    end
  end

  def update_seller_stock
    seller_stock = UserStock.where(user: seller, stock: stock).first
    if seller_stock.exists?
      total_shares = seller_stock.shares - shares
      seller_stock.update(shares: total_shares)
    else
      UserStock.create(user: seller, stock: stock, shares: shares)
    end
  end
end
