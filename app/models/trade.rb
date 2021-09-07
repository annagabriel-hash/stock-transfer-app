class Trade < ApplicationRecord
  belongs_to :buy
  belongs_to :sell, optional: true
  belongs_to :stock
  validates :shares, presence: true
  validates :price, presence: true
  after_create :update_buyer_stock, :update_seller_stock, :update_balance, :close_orders

  def amount
    price * shares
  end

  def buyer
    buy.user
  end

  def seller
    sell.user
  rescue NoMethodError
    nil
  end

  def new_balance
    new_balance = {}
    prev_balance = buyer.balance
    new_balance[:buyer] = prev_balance - amount
    if sell.present?
      prev_balance = seller.balance
      new_balance[:seller] = prev_balance + amount
    end
    new_balance
  end

  private

  def update_buyer_stock
    buyer_stock = UserStock.where(user: buyer, stock: stock).first
    if buyer_stock.present?
      buyer_stock.shares += shares
      buyer_stock.save
    else
      UserStock.create(user: buyer, stock: stock, shares: shares)
    end
  end

  def close_orders
    buy.close!
    sell.close! if sell.present?
  end

  def update_seller_stock
    return if sell.blank?

    seller_stock = UserStock.where(user: seller, stock: stock).first
    total_shares = seller_stock.shares - shares
    seller_stock.update(shares: total_shares)
  end

  def update_balance
    buyer.update(balance: new_balance[:buyer])
    seller.update(balance: new_balance[:seller]) if seller.present?
  end
end
