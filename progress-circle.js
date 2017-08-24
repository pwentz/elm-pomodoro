var ProgressBar = require("progressbar.js");
var elm;

// TODO:
// when updating ticker, elm must send over original time

function initCircle(data) {
  var minutes = String(data[0])
  var seconds = String(data[1])

  var container = document.getElementById("timer-container");
  var bar = new ProgressBar.Circle(container, {
      color: '#aaa',
      strokeWidth: 2,
      trailWidth: 1,
      easing: 'easeInOut',
      duration: 1400,
      from: { color: '#aaa', width: 1 },
      to: { color: '#333', width: 2 },
      style: {
        color: '#f00',
        position: 'absolute',
        left: '10%',
        top: '10%',
        padding: 0,
        margin: 0
      },
      step: function(state, circle) {
        circle.path.setAttribute('stroke', state.color);
        circle.path.setAttribute('stroke-width', state.width);
      }
  })

  bar.setText(minutes + ":" + seconds)
  bar.animate(1.0)
}

(function(window) {
  elm = Elm.Main.embed(document.getElementById("elm"));

//   var safe = function(fn, data) {
//     try { fn(data) }
//     catch (err) { elm.ports.jsError.send(err.message) }
//   };
  elm.ports.initCircle.subscribe(initCircle);
}(window));
