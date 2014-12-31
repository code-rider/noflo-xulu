// JavaScript Document
var noflo = require('noflo');

exports.getComponent = function () {
  var c = new noflo.Component();

  c.inPorts.add('in', function (event, payload) {
    if (event !== 'data') {
      return;
    }
    function readDirectory(file){
      if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
      }
      else {// code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
      }
      xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState==4 && xmlhttp.status==200) {
          var allText = xmlhttp.responseText.split(",");
          var empty = allText.pop();
          for(var i = 0; i < allText.length; i++) {
            c.outPorts.out.send(allText[i]);
          }
		  c.outPorts.out.disconnect();
        }
      }
      xmlhttp.open("GET",file,true);
      xmlhttp.send();
    }
	readDirectory("directory_reader.php")
    // Do something with the packet, then
  });
  c.outPorts.add('out');
  return c;
};