noflo = require 'noflo'

class tweets_get_hashTags extends noflo.Component
  description: 'The tweets_get_hashTags component receives a tweet string in the in port,
    and collect all hash tags from receiving data and send all uniqe tags one by one to the out port'

  constructor: ->
    @tweets = []
    @groups = []
    @hash_tags =[]

    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: 'Tweet json in string format for filtring'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by user id'

    @inPorts.in.on 'begingroup', (group) =>
      @groups.push(group)
    @inPorts.in.on 'data', (data) =>
      @tweets.push data
	
    @inPorts.in.on 'disconnect', (data) =>
      return @outPorts.out.disconnect() if @tweets.length is 0
      @tweets.forEach (tweet) =>
        tweetObj = JSON.parse tweet
        if tweetObj.entities.hashtags.length > 0 
          tweet_tags = tweetObj.entities.hashtags.map (hashTag) -> hashTag.text
          tweet_tags.forEach (tweet_tag) =>
            @hash_tags.push tweet_tag
      
      unique_tags = @hash_tags.unique()
      unique_tags.forEach (unique_tag) =>
        @outPorts.out.send unique_tag
      @outPorts.out.disconnect()

  Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output

exports.getComponent = ->
  new tweets_get_hashTags()