class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
  after_create :set_user_status

  def set_user_status
    return user.pending! if role.name == 'broker'
    return user.approved! if role.name == 'buyer'
  end
end
