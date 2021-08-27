module ApplicationHelper
  def basic_account?(user)
    user.roles.count == 1 && !user.admin?
  end
end
