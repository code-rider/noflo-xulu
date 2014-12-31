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
            var allText = rawFile.responseText.split(",");
            var empty = allText.pop();
            for(var i = 0; i < allText.length; i++) {
              c.outPorts.out.send(allText[i]);
            }  
            c.outPorts.out.disconnect();
          }
        }
      }
      rawFile.send(null);
    }
	readTextFile("directory_reader.php")
    // Do something with the packet, then
  });
  c.outPorts.add('out');
  return c;
};