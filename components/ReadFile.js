// JavaScript Document
var noflo = require('noflo');

exports.getComponent = function () {
  var c = new noflo.Component();

  c.inPorts.add('in', function (event, payload) {
    if (event == 'disconnect') {
      c.outPorts.out.disconnect();
    }
	if (event == 'data') {
	  function readTextFile(file){	  
        var rawFile = new XMLHttpRequest();
        rawFile.open("GET", file, false);
        rawFile.onreadystatechange = function () {
          if(rawFile.readyState === 4) {
            if(rawFile.status === 200 || rawFile.status == 0) {
              var allText = rawFile.responseText.split("\n");
              for(var i = 0; i < allText.length; i++) {
                if(allText[i].length > 0){
                  c.outPorts.out.send(allText[i]);
                }
              }
            }
          }
        }
        rawFile.send(null);
      }
	  readTextFile(payload)
	}
    // Do something with the packet, then
  });
  c.outPorts.add('out');
  return c;
};