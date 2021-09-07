class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  has_many :user_stocks, dependent: :destroy
  has_many :stocks, through: :user_stocks
  has_many :buys, dependent: :destroy
  has_many :sells, dependent: :destroy

  before_create :set_default_role
  after_create :send_email, if: :approved?
  enum status: { pending: 0, approved: 1 }

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    admin_role_id = Role.find_by(name: 'admin').id
    roles.exists?(admin_role_id)
  end

  def upgrade_account
    roles << Role.find_by(name: 'broker')
  end

  def shares(stock)
    UserStock.where(user_id: id, stock: stock).first.shares
  rescue StandardError
    0
  end

  def trades
    Trade.where(buyer: user).or(Trade.where(seller: user))
  end

  private

  def set_default_role
    roles << Role.find_by(name: 'buyer') if roles.empty?
  end

  def send_email
    UserMailer.welcome_email(self).deliver_later
  end
end
