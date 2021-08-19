class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  before_create :set_default_role

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def set_default_role
    roles << Role.find_by(name: 'buyer') if roles.empty?
  end
end
