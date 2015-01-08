noflo = require 'noflo'

class tweet_date_filter extends noflo.Component
  description: 'The tweet_date_filter component receives a tweet string in the in port,
    and send filtered tweets to the out port by date range'
  icon: 'filter'

  constructor: ->
    @start_date = null
    @end_date = null
    @tweets = []
    @groups = []

    @inPorts = new noflo.InPorts
      start_date:
        datatype: 'date'
        description: 'start date for filtering data'
        required: yes
      end_date:
        datatype: 'date'
        description: 'end date for filtering data'
      in:
        datatype: 'string'
        description: 'Tweet json in string format for filtring'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
        description: 'send filtered data'

    @inPorts.start_date.on 'data', (@start_date) =>
      do @filter if @end_date
    @inPorts.end_date.on 'data', (@end_date) =>
      do @filter if @start_date


    @inPorts.in.on 'begingroup', (group) =>
      @groups.push(group)
    @inPorts.in.on 'data', (data) =>
      @tweets.push data
	
    @inPorts.in.on 'disconnect', (data) =>
      @outPorts.out.disconnect()
      
      
  filter: ->
    @tweets.forEach (tweet) =>
      tweetObj = JSON.parse tweet
      tweet_date = new Date(tweetObj.created_at).getTime()
      @outPorts.out.send tweet if tweet_date >= @start_date.getTime() and tweet_date <= @end_date.getTime()
    @outPorts.out.disconnect()
    @start_date = null
    @end_date = null
    @tweets = []
    @groups = []
	  
exports.getComponent = ->
  new tweet_date_filter()