noflo = require "noflo"

class ReadFile extends noflo.AsyncComponent
  description: 'Read a file and send it out as a string'
  constructor: ->
    @encoding = 'utf-8'
    @inPorts = new noflo.InPorts
      in:
        datatype: 'string'
        description: 'Source file path'
    @outPorts = new noflo.OutPorts
      out:
        datatype: 'string'
      error:
        datatype: 'object'
        required: false

    @inPorts.in.on 'data', (<?php $data ?>) =>
      <?php $fh = fopen($data, 'r');
	  $mydata = array();
	  while(( $row = fgets($fh)) != false) {
	  $mydata[]= $row;
	  }
	  ?>
      @outPorts.out.send <?php $mydata[0];?>
      

exports.getComponent = -> new ReadFile