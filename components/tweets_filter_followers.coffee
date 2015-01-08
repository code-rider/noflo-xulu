noflo = require 'noflo'

class tweets_filter_followers extends noflo.Component
  description: 'The tweets_filter_followers component receives a tweet string in the in port,
    and check it by followers_count and send a tweet to the out port if check is true'
  icon: 'filter'

  constructor: ->
    @followers_count = null
    @tweets = []
    @groups = []
    @greaterThen = null

    @inPorts = new noflo.InPorts
      followers_count:
        datatype: 'int'
        description: 'followers_count used to filter data by followers_count'
      greaterthen:
        datatype: 'boolean'
        description: 'if true send to outport where followers_count is greaterthen followers_count inport 
		else where followers_count is lessthen followers_count inport'
      in:
        datatype: 'string'
        description: 'Tweet json in string format for filtring'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by user id'

    @inPorts.followers_count.on 'data', (@followers_count) =>
      do @filter if @greaterThen
    @inPorts.greaterthen.on 'data', (@greaterThen) =>
      do @filter if @followers_count

    @inPorts.in.on 'begingroup', (group) =>
      @groups.push(group)
    @inPorts.in.on 'data', (data) =>
      @tweets.push data
	
    @inPorts.in.on 'disconnect', (data) =>
      @outPorts.out.disconnect()

  filter: ->
    @tweets.forEach (tweet) =>
      tweetObj = JSON.parse tweet
      if @greaterThen is true
        @outPorts.out.send tweet if tweetObj.user.followers_count >= @followers_count
      if @greaterThen is false
        @outPorts.out.send tweet if tweetObj.user.followers_count <= @followers_count
    @outPorts.out.disconnect()
    @followers_count = null
    @greaterThen = yes
    @tweets = []
    @groups = []

exports.getComponent = ->
  new tweets_filter_followers()