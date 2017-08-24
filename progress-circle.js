var ProgressBar = require("progressbar.js");
var elm;
var bar;


function toTime(timeData) {
  var minutes = String(timeData[0]);
  var seconds = String(timeData[1]);

  return minutes + ":" + seconds;
};

function pctFromTime(data) {
  var currentMin = data.current[0]
  var currentSec = data.current[1]
  var currentTotalSeconds = (currentMin * 60) + currentSec

  var originalMin = data.original[0]
  var originalSec = data.original[1]
  var originalTotalSeconds = (originalMin * 60) + originalSec

  return currentTotalSeconds / originalTotalSeconds
}

function initCircle(data) {
  var container = document.getElementById("timer-container");
  var startingColor = '#' + data.colors[0]
  var endColor = '#' + data.colors[1]

  bar = new ProgressBar.Circle(container, {
      color: startingColor,
      strokeWidth: 2,
      trailWidth: 1,
      easing: 'easeInOut',
      duration: 1400,
      from: { color: startingColor, width: 1 },
      to: { color: endColor, width: 2 },
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

  bar.setText(toTime(data.time));
  bar.animate(1.0);
}

function updateProgressCircle(data) {
  var currentMin = String(data.current[0])
  var currentSec = String(data.current[1])

  var pct = pctFromTime(data);

  bar.set(pct)
  bar.setText(currentMin + ":" + currentSec)
};


function timerTransition(data) {
  bar.destroy();
  initCircle(data);
};

(function(window) {
  elm = Elm.Main.embed(document.getElementById("elm"));

  var propagateFailure = function(fn, data) {
    try { fn(data) }
    catch (err) { elm.ports.jsError.send(err.message) }
  };

  var actions = {
    initCircle: initCircle,
    updateProgressCircle: updateProgressCircle,
    timerTransition: timerTransition
  };

  Object.keys(actions).forEach(function(action) {
    var safeAction = propagateFailure.bind(null, actions[action]);
    elm.ports[action].subscribe(safeAction);
  });
}(window));
