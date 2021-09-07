class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  def value
    stock.market_price * shares
  end
end
