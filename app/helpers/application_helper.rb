module ApplicationHelper
  def basic_account?(user)
    user.roles.count == 1 && !user.admin?
  end

  def max_shares(price)
    (current_user.balance / price).floor
  end

  def shares_owned(ticker)
    stock = Stock.where(ticker: ticker).first
    user_stock = UserStock.where(user: current_user, stock: stock).first
    user_stock.shares
  rescue StandardError
    0
  end
end
