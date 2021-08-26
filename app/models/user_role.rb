class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
  before_create :set_user_status

  def set_user_status
    return user.status = 'pending' if role.name == 'broker'
    return user.status = 'approved' if role.name == 'buyer'
  end
end
