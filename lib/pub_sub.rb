# Topic-based publish/subscribe channel implementation.



#
# Topic-based publish/subscribe channel.  Maintains a map of topics to
# subscriptions.  When a message is published to a topic, all functions
# subscribed to that topic are invoked in the order they were added.
# Uncaught errors abort publishing.
# 
# @constructor
# @extends {goog.Disposable}
# 
class PubSub
  def initialize(*args)
    @key = 1
    @subscriptions = {}
    @topics = {}
    @publishDepth=0
    self
  end
  def subscribe(topic, blk=nil, &block)
    #First subscription to this topic; initialize subscription key array.
    keys = (@topics[topic] ||= [])
    # Push the tuple representing the subscription onto the subscription array.
    key = @key
    @subscriptions[key] = topic
    @subscriptions[key+1] = blk || block
    @key += 2
    # Push the subscription key onto the list of subscriptions for the topic.
    keys << key
    # Return the subscription key.
    return key
  end

  #
  # Subscribes a single-use function to a topic.  The function is invoked as a
  # method on the given {@code opt_context} object, or in the global scope if
  # no context is specified, and is then unsubscribed.  Returns a subscription
  # key that can be used to unsubscribe the function from the topic via
  # {@link #unsubscribeByKey}.
  #
  # @param {string} topic Topic to subscribe to.
  # @param {Function} fn Function to be invoked once and then unsubscribed when
  #     a message is published to the given topic.
  # @param {Object=} opt_context Object in whose context the function is to be
  #     called (the global scope if none).
  # @return {number} Subscription key.
  #  

  def subscribeOnce(topic, blk=nil, &block)
    key = subscribe(topic) do |*args|
      (blk || block).call(*args)
      unsubscribeByKey(key)
    end
  end
  #
  # Removes a subscription based on the key returned by {@link #subscribe}.
  # No-op if no matching subscription is found.  Returns a Boolean indicating
  # whether a subscription was removed.
  # 
  # @param {number} key Subscription key.
  # @return {boolean} Whether a matching subscription was removed.
  #
  def unsubscribeByKey(key)
    if(@publishDepath != 0)
      @pendingKeys ||= []
      @pendingKeys << key
      return false
    end

    if topic = @subscriptions[key]  # when topic exists
      keys.delete(key) if keys = @topics[key] # when keys exists
      @subscription.delete(key)
      @subscription.delete(key + 1)
    end
    return !!topic
  end
  #
  # Publishes a message to a topic.  Calls functions subscribed to the topic in
  # the order in which they were added, passing all arguments along.  If any of
  # the functions throws an uncaught error, publishing is aborted.
  #
  # @param {string} topic Topic to publish to.
  # @param {...*} var_args Arguments that are applied to each subscription
  #     function.
  # @return {boolean} Whether any subscriptions were called.
  #  
  def publish(topic, *args)
    return false unless keys = @topics[topic]
    @publishDepth+=1
    keys.each do |key|
      @subscriptions[key + 1].call(*args)
    end
    @publishDepth-=1
    if @pendingKeys && @publishDepth == 0
      while pendingKey = @pendingKeys.pop
        unsubscribeByKey(pendingKey)
      end
    end
    return keys.size != 0
  end

  # Clears the subscription list for a topic, or all topics if unspecified.
  # @param {string=} opt_topic Topic to clear (all topics if unspecified).
  #
  def clear(topic=nil)
    if topic
      if keys = @topics[topic]
        keys.each do |key|
          unsubscribeByKey(key)
        end
        @topics.delete(topic)
      end
    else
      @subscriptions.clear
      @topics.clear
      # We don't reset @key on purpose, because we want subscription keys to be
      # unique throughout the lifetime of the application.  Reusing subscription
      # keys could lead to subtle errors in client code.      
    end
  end
  #
  # Returns the number of subscriptions to the given topic (or all topics if
  # unspecified).
  # @param {string=} opt_topic The topic (all topics if unspecified).
  # @return {number} Number of subscriptions to the topic.
  #
  def getCount(topic=nil)
    return ((keys = @topics[topic]) ?  keys.size : 0) if topic
    return @topics.inject(0){|s, t|s+t[1].size}
  end
end

if $0 == __FILE__
  class Test < PubSub
    attr :keys
    def initialize
      super
      @keys = []
      @keys << subscribe( 'test', method(:update))
      @keys << subscribe("test"){|*args| puts 'from proc---'; p args; puts '======'}
    end
    def update(*args)
      puts '--method--'
      p args
      puts '=========='
    end
    public
    def test(*args)
      publish('test', *args)
    end
  end
  a = Test.new
  a.test(1,2,3)
  a.test(2,3,4)
  a.keys.each do |k| a.unsubscribeByKey(k); end
end
