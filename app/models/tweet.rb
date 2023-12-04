class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :twitter_account

  validates :body, length: { minimum: 1, maximum: 280 }
  validates :publish_at, presence: true

  after_initialize do
    self.publish_at ||= 24.hour.from_now
  end

  after_save_commit do
    if publish_at_previously_changed?
      TweetJob.set(wait_until: publish_at).perform_later(self)
    end
  end

  def published?
    tweet_id?  #con el ? me devuelve tru o false no el valor
  end

  def publish_to_twitter!
    #greet = twitter_account.client_x
    twitter_account_client = twitter_account.client
    tweet_body = {text: "#{body}"}
    tweet = twitter_account_client.post("tweets", tweet_body.to_json)
    update(tweet_id: tweet["data"]["id"])
  end
end
