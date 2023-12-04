class TwitterAccount < ApplicationRecord
  has_many :tweets
  belongs_to :user

  validates :username, uniqueness: true

  def client
    x_credentials = {
      api_key:             Rails.application.credentials.twitter[:api_key], 
      api_key_secret:      Rails.application.credentials.twitter[:api_secret],
      access_token:        self.token,
      access_token_secret: self.secret
      }
      x_client = X::Client.new(**x_credentials)
  end
  def client_x
    "hola"
  end
end
