noflo = require 'noflo'

class tweets_get_screenNames extends noflo.Component
  description: 'The tweets_get_screenNames component receives a tweet string in the in port,
    and send only unique screen names to the out port'

  constructor: ->
    @tweets = []
    @groups = []
    @screenNames = []

    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: 'Tweet json in string format for filtring'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send unique screen name'

    @inPorts.in.on 'begingroup', (group) =>
      @groups.push group
    @inPorts.in.on 'data', (data) =>
      @tweets.push data
	
    @inPorts.in.on 'disconnect', (data) =>
      return @outPorts.out.disconnect() if @tweets.length is 0
      @tweets.forEach (tweet) =>
        tweetObj = JSON.parse tweet
        @screenNames.push tweetObj.user.screen_name
      unique_names = @screenNames.unique()
      unique_names.forEach (names) =>
        @outPorts.out.send names
      @outPorts.out.disconnect()

  Array::unique = ->
    output = {}
    output[@[key]] = @[key] for key in [0...@length]
    value for key, value of output

exports.getComponent = ->
  new tweets_get_screenNames()