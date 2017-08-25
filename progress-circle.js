var ProgressBar = require("progressbar.js");
var elm;
var bar;


function pctFromTime(data) {
  var currentMin = data.current[0]
  var currentSec = data.current[1]
  var currentTotalSeconds = (currentMin * 60) + currentSec

  var originalMin = data.original[0]
  var originalSec = data.original[1]
  var originalTotalSeconds = (originalMin * 60) + originalSec

  return currentTotalSeconds / originalTotalSeconds
}

function timeFromPct(pct, time) {
  var defaultMin = time[0]
  var defaultSec = time[1]

  var totalSeconds = pct * ((defaultMin * 60) + defaultSec)
  var min = Math.floor(totalSeconds / 60)
  var sec = Math.round((totalSeconds % 60) * 10) / 10

  return [min, sec]
};


function formatTime(time) {
  var min = time[0];
  var sec = time[1];

  var strSec;

  if (String(sec).length === 1) {
    strSec = "0" + String(sec);
  } else {
    strSec = String(sec);
  };

  return String(min) + ":" + strSec;
};


function initCircle(data) {
  var container = document.getElementById("timer-container");
  var startingColor = '#' + data.colors[0]
  var endColor = '#' + data.colors[1]

  bar = new ProgressBar.Circle(container, {
      color: startingColor,
      strokeWidth: 2,
      trailWidth: 1,
      easing: 'easeInOut',
      duration: 800,
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
      text: {
        value: formatTime(data.time)
      },
      step: function(state, circle) {
        circle.path.setAttribute('stroke', state.color);
        circle.path.setAttribute('stroke-width', state.width);

        var currTime = timeFromPct(circle.value(), data.time);

        circle.setText(String(currTime[0]) + ":" + String(currTime[1]))
      }
  })

  bar.text.style.fontSize = "3rem"
  bar.animate(1.0);
}

function updateProgressCircle(data) {
  bar.set(pctFromTime(data));
  bar.setText(formatTime(data.current));
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
