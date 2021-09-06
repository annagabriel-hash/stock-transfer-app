module ApplicationHelper
  def basic_account?(user)
    user.roles.count == 1 && !user.admin?
  end

  def max_shares(price)
    (current_user.balance / price).floor
  end
end
