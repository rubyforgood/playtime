class User < ApplicationRecord
  validates :email, uniqueness: true
end
