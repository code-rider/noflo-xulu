noflo = require 'noflo'

class PacketCounter extends noflo.Component
  description: ' The PacketCounter component receives a data in the in port,
    in diffrent packets and count them and send total count to out port'
  icon: 'sort-numeric-asc'

  constructor: ->
    @packets = []
    @groups = []

    @inPorts = new noflo.InPorts
      in:
        datatype: 'all'
        description: 'to count packets'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'int'
        description: 'send the total number of input packets)'

    @inPorts.in.on 'begingroup', (group) =>
      @groups.push(group)
    @inPorts.in.on 'data', (data) =>
      @packets.push data
      
    @inPorts.in.on 'disconnect', (data) =>
      return @outPorts.out.disconnect() if @packets.length is 0
      @outPorts.out.send @packets.length
      
      @outPorts.out.disconnect()
      @packets = []
      @groups = []

exports.getComponent = ->
  new PacketCounter()