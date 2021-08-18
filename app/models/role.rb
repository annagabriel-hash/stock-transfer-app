class Role < ApplicationRecord
  before_save { name.downcase! }
  validates :name, uniqueness: { case_sensitive: false }, presence: true
end
