noflo = require 'noflo'

class tweets_get_tweetText extends noflo.Component
  description: 'The tweets_get_tweetText component receives a tweet string in the in port,
    and send tweet text to the out port'
  icon: 'envelope'

  constructor: ->
    @tweets = []
    @groups = []
    @tweetText =[]

    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: 'Tweet json in string format for filtring'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'tweet text'

    @inPorts.in.on 'begingroup', (group) =>
      @groups.push(group)
    @inPorts.in.on 'data', (data) =>
      @tweets.push data
	
    @inPorts.in.on 'disconnect', (data) =>
      return @outPorts.out.disconnect() if @tweets.length is 0
      @tweets.forEach (tweet) =>
        tweetObj = JSON.parse tweet
        @outPorts.out.send tweetObj.text
      @outPorts.out.disconnect()

exports.getComponent = ->
  new tweets_get_tweetText()