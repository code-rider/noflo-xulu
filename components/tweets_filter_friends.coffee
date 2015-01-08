noflo = require 'noflo'

class tweets_filter_friends extends noflo.Component
  description: 'The tweets_filter_friends component receives a tweet string in the in port,
    and check it by friends_count and send a tweet to the out port if check is true'
  icon: 'filter'

  constructor: ->
    @friends_count = null
    @tweets = []
    @groups = []
    @greaterThen = null

    @inPorts = new noflo.InPorts
      friends_count:
        datatype: 'int'
        description: 'friends_count in port used to filter data by friends_count'
      greaterthen:
        datatype: 'boolean'
        description: 'if true send to outport where friends_count is greaterthen friends_count inport 
		else where friends_count is lessthen friends_count inport'
      in:
        datatype: 'string'
        description: 'Tweet json in string format for filtring'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by user id'

    @inPorts.friends_count.on 'data', (@friends_count) =>
      do @filter if @greaterThen
    @inPorts.greaterthen.on 'data', (@greaterThen) =>
      do @filter if @friends_count

    @inPorts.in.on 'begingroup', (group) =>
      @groups.push(group)
    @inPorts.in.on 'data', (data) =>
      @tweets.push data
	  
    @inPorts.in.on 'disconnect', (data) =>
      @outPorts.out.disconnect()

  filter: ->
    return @outPorts.out.disconnect() if @tweets.length is 0
    @tweets.forEach (tweet) =>
      tweetObj = JSON.parse tweet
      if @greaterThen is true
        @outPorts.out.send tweet if tweetObj.user.friends_count >= @friends_count
      if @greaterThen is false
        @outPorts.out.send tweet if tweetObj.user.friends_count <= @friends_count
    @outPorts.out.disconnect()
    @friends_count = null
    @tweets = []
    @groups = []

exports.getComponent = ->
  new tweets_filter_friends()