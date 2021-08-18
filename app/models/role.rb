class Role < ApplicationRecord
  before_save { name.downcase! }
  validates :name, uniqueness: { case_sensitive: false }, presence: true
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
end
