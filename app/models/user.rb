class User < ApplicationRecord
  rolify
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
