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
                return rawFile.responseText;
                //alert(allText);
            }
        }
      }
      rawFile.send(null);
    }
    // Do something with the packet, then
    c.outPorts.out.send(readTextFile("text.txt"));
  });
  c.outPorts.add('out');
  return c;
};