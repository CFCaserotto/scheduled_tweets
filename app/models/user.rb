class User < ApplicationRecord
    #password:string               -- virtual with has_secure_password
    #password_confirmation:string  --virtual with has_secure_password
    has_secure_password

    has_many :twitter_accounts
    has_many :tweets

    validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "is not a valid email address" }
    validates :password, presence: true
end
