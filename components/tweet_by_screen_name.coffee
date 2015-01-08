noflo = require 'noflo'

class tweet_by_screen_name extends noflo.Component
  description: 'The tweet_by_screen_name component receives a tweet string in the in port,
    and check it by user id and send a tweet to the out port if check is true'
  icon: 'filter'

  constructor: ->
    @screen_name = null
    @tweets = []
    @groups = []

    @inPorts = new noflo.InPorts
      screen_name:
        datatype: 'string'
        description: 'User id used to to filter data by user id'
      in:
        datatype: 'string'
        description: 'Tweet json in string format for filtring'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by user id'

    @inPorts.screen_name.on 'data', (data) =>
      @screen_name = data

    @inPorts.in.on 'begingroup', (group) =>
      @groups.push(group)
    @inPorts.in.on 'data', (data) =>
      @tweets.push data
	
    @inPorts.screen_name.on 'disconnect', (data) =>
      return @outPorts.out.disconnect() if @tweets.length is 0
      @tweets.forEach (tweet) =>
        tweetObj = JSON.parse tweet
        @outPorts.out.send tweet if tweetObj.user.screen_name is @screen_name
      @outPorts.out.disconnect()
      @screen_name = null
      @tweets = []
      @groups = []

exports.getComponent = ->
  new tweet_by_screen_name()