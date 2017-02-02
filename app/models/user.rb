class User < ApplicationRecord
  rolify
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true
  enum device_type: { android: 0, ios: 1 }
end
