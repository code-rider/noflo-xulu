fs = require "fs"
noflo = require "noflo"

class ReadFile extends noflo.AsyncComponent
  description: 'Read a file and send it out as a string'
  constructor: ->
    @encoding = 'utf-8'
    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: 'Source file path'
      encoding:
        datatype: 'string'
        description: 'File encoding'
        default: 'utf-8'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
      error:
        datatype: 'object'
        required: false

    @inPorts.encoding.on 'data', (@encoding) =>

    super()

  doAsync: (fileName, callback) ->
    fs.readFile fileName, @encoding, (err, data) =>
      return callback err if err?
      @outPorts.out.beginGroup fileName
      @outPorts.out.send data
      @outPorts.out.endGroup()
      callback null

exports.getComponent = -> new ReadFile
