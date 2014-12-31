// JavaScript Document
var noflo = require('noflo');

exports.getComponent = function () {
  var c = new noflo.Component();

  c.inPorts.add('in', function (event, payload) {
    if (event !== 'data') {
      return;
    }
    function readDirectory(){
  	$.ajax({  
		   
	type: "POST",  
	url:"directory_reader.php",  
	
	beforeSend: function()
	{
 	},
	success: function(resp)
	{  
	  var allText = resp.split(",");
      var empty = allText.pop();
      for(var i = 0; i < allText.length; i++) {
        c.outPorts.out.send(allText[i]);
      }
      c.outPorts.out.disconnect();
	
    }, 
	
	complete: function()
    {
	},
	 
	error: function(e)
	{  
	alert('Error: ' + e);  
	}  
    }); 
 }
	readDirectory("directory_reader.php")
    // Do something with the packet, then
  });
  c.outPorts.add('out');
  return c;
};