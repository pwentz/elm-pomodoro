var remote = require('electron').remote;
var state = remote.require('./');


(function(window) {
  console.log(state)
}(window));
