noflo = require 'noflo'

class tweet_by_user_id extends noflo.Component
  description: 'The tweet_by_user_id component receives a tweet string in the in port,
    and check it by user id and send a tweet to the out port if check is true'

  constructor: ->
    @user_id = null
    @tweets = []
    @groups = []

    @inPorts = new noflo.InPorts
      user_id:
        datatype: 'string'
        description: 'User id used to to filter data by user id'
      in:
        datatype: 'string'
        description: 'Tweet json in string format for filtring'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data by user id'

    @inPorts.user_id.on 'data', (data) =>
      @user_id = data

    @inPorts.in.on 'begingroup', (group) =>
      @groups.push(group)
    @inPorts.in.on 'data', (data) =>
      @tweets.push data
	
    @inPorts.user_id.on 'disconnect', (data) =>
      return @outPorts.out.disconnect() if @tweets.length is 0
      @tweets.forEach (tweet) =>
        tweetObj = JSON.parse tweet
        @outPorts.out.send tweet if tweetObj.user.id_str is @user_id
      @outPorts.out.disconnect()
      @user_id = null
      @tweets = []
      @groups = []

exports.getComponent = ->
  new tweet_by_user_id()