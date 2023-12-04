class TweetJob < ApplicationJob
  queue_as :default

  #def perform(*args)
    # Do something later
  #end
  def perform(tweet)
    #binding.break
    return if tweet.published?
    return if tweet.publish_at > Time.current

    tweet.publish_to_twitter!
  end
end

#Push the publish_at forward
#noo -> 8am

#8am --> sets tweet id
#Noon --> published, does nothing

#Push the publish_at forward
#9am -> 1pm
#9am -->should do nothing
#1pm--> should publish the tweet and set the tweet_id



