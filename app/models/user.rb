class User < ApplicationRecord
    has_many :carts
    has_many :products, through: :carts

    has_secure_password

    validates :username, presence: true
    validates :username, uniqueness: true
    validates :username, length: { minimum: 4 }
end
