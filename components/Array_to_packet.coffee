noflo = require 'noflo'

class Array_to_packet extends noflo.Component
  description: ' The Array_to_packet component receives a array in the in port,
    and send each part as a separate packet to the out port'
  icon: 'dropbox'

  constructor: ->
    @arrayPacket = []

    @inPorts = new noflo.InPorts
      in:
        datatype: 'array'
        description: 'String to split'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'all'
        description: 'send each part of array as a separate packet to the out port'

    @inPorts.in.on 'data', (data) =>
      @arrayPacket =  data

    @inPorts.in.on 'disconnect', (data) =>
      return @outPorts.out.disconnect() if @arrayPacket.length is 0
      @arrayPacket.forEach (line) =>
        @outPorts.out.send line
      @outPorts.out.disconnect()
      @arrayPacket = []

exports.getComponent = ->
  new Array_to_packet()