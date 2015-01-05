noflo = require 'noflo'

class AppendChild extends noflo.Component
  description: 'Append elements as children of a parent element'
  constructor: ->
    @parent = null
    @children = []
    @groups = []
    @parentElementid = null
    @childElementName = null
    
    @inPorts = new noflo.InPorts
      child_string:
        datatype: 'string'
        description: 'string to append'
      parent_element_id: 
        datatype: 'string'
        description: 'parrent id to append'
      child_element_name:
        datatype: 'string'
        description: 'children element name wants to create as child'
    @outPorts = {}

    @inPorts.parent_element_id.on 'data', (@parentElementid) =>
      do @append if @childElementName
    
    @inPorts.child_element_name.on 'data', (@childElementName) =>
      do @append if @parentElementid
    
    @inPorts.child_string.on 'begingroup', (group) =>
      @groups.push(group)

    @inPorts.child_string.on 'data', (data) =>
      unless @parentElementid and @childElementName
        @children.push data
        return
      child_ele = document.createElement @childElementName
      child_ele.innerHTML = data
      document.getElementById(@parentElementid).appendChild child_ele
    
    
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
