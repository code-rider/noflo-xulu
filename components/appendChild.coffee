noflo = require 'noflo'

class AppendChild extends noflo.Component
  description: 'Append elements as children of a parent element'
  constructor: ->
    @parent = null
    @children = []
    @groups = []
    @parentElementid = null
    @childElementName = null
    
    @inPorts =
      childString: new noflo.Port 'string'
      parentElementid: new noflo.Port 'string'
      childElementName: new noflo.Port 'string'
    @outPorts = {}

    @inPorts.parentElementid.on 'data', (@parentElementid) =>
      do @append if @childElementName
    
    @inPorts.childElementName.on 'data', (@childElementName) =>
      do @append if @parentElementid
    
    @inPorts.childString.on 'begingroup', (group) =>
      @groups.push(group)

    @inPorts.childString.on 'data', (data) =>
      @children.push data
    
    
  append: ->
    return if @children.length is 0
    @children.forEach (child) =>
      child_ele = document.createElement @childElementName
      child_ele.innerHTML = child
      document.getElementById(@parentElementid).appendChild child_ele
        
    @parent = null
    @children = []
    @groups = []
    @parentElementid = null
    @childElementName = null

exports.getComponent = -> new AppendChild
