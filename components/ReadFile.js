// JavaScript Document
var noflo = require('noflo');

exports.getComponent = function () {
  var c = new noflo.Component();

  c.inPorts.add('in', function (event, payload) {
    if (event !== 'data') {
      return;
    }
	function readTextFile(file){	  
      var rawFile = new XMLHttpRequest();
      rawFile.open("GET", file, false);
      rawFile.onreadystatechange = function () {
        if(rawFile.readyState === 4) {
            if(rawFile.status === 200 || rawFile.status == 0) {
                var allText = rawFile.responseText.split("\n");
                c.outPorts.out.send(allText);
				c.outPorts.out.disconnect();
            }
        }
      }
      rawFile.send(null);
    }
	readTextFile("text.txt")
    // Do something with the packet, then
  });
  c.outPorts.add('out');
  return c;
};