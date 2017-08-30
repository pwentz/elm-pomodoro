var electron = require('electron');
var Tray = electron.Tray
var Menu = electron.Menu
var MenuItem = electron.MenuItem
var nativeImage = electron.nativeImage
var BrowserWindow = electron.BrowserWindow;  // Module to create native browser window.
var base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAAAo1JREFUOBGdlDlolVEQRv8Yk6C4i3ELimTBFQlREYMLgqighUVstLGLhVspohAERSV9SGEsVLBwA1tFQcHGWIipBLUwQXCN4oIx8Zz//RPfEl7QD867987cNzN33vCSpLwqityeJxTZ/vsYgYqTlA1YOYZ3IjbtNTAZfmT7IVZVBd5R8QJtaiS35ALE3srkNwyDgVrAwIOgjsNi6AWDBH7HvQld04yuVqhTzYCd0ADboBr2QS1cgy7og40wBb7DE7gFXyBtmR/5QY9wtiptr8FKZ4HJbI1JtFnZOzCQdxvBBEfhJhToIiefYeB5MAnULuiHeLbrYzgBq0EtgR7Q1waj6mBnK3zeXFgFqgmuwBawqnNgf+9CQQDOqhsGwBjJMvgGB2AFmPUSqN3Qmu7+fjgpzXAK6jOzNmXLDHzMwxl4BtOz9SvrQlD+OMppsZcVHjJ5Z0G21x/yR7yhYS3cg0Vgxe3wBvyBTGIwX2GrlN/R5x17r38YZoJ6CbVemgpemgav4BGoqMKgolwN4owbMJKyTdbAfNA3YmZHxmc9B3+Y6FcEwzSm9Js87q1k7wga660OR2c7fIKz8BOUlY2n6uxCA+tssF229iEkS8GqD3tAvkL+Ree5vAkOwXuIHz8dHZ+0FUJWUy6B/W2CC7AHbIX/KyehQD2cfP7BAmtuzEwS1GR+x3M/tMIG+Ah3YFTOZ6iDzS+4DzvAqsrJKjvBSbgKVaAq44sGjzldz/40rIMX8ACewgD4Iv+UloNVtsAH8P5lULZvKAJrMLh9jmnYzH4vmGAORL/1f4Y+uA3XISYpDcq55Kkm0mk7Qj6vDqzU8fRvsx+cpJB3fHEUFfaS1eqjXyXOPINFxEvyzEnyBwIBioQ36fdtAAAAAElFTkSuQmCC'


// ACTIONS

function dispatchPauseToggle(state) {
  var togglePauseAction = "elm.ports.menuBarTogglePause.send('')"
  state.mainWindow.webContents.executeJavaScript(togglePauseAction);
}

// STATE
var state = {
  isTimerRendered: false,
  mainWindow: null,
  tray: null,
  menuIcon: nativeImage.createFromDataURL(base64Icon),
  isPaused: false,
  menu: new Menu(),
  menuItems: {
    render: new MenuItem({
      label: "Timer",
      click: function() { toggleWindow(state) }
    }),
    pauseTimer: new MenuItem({
      label: "Pause",
      click: function() {
        togglePause(state)
        dispatchPauseToggle(state)
      }
    })
  }
}

var app = electron.app;
// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is GCed.
// var mainWindow = null;


// Quit when all windows are closed.
app.on('window-all-closed', function() {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform != 'darwin') {
    app.quit();
  }
});


app.on('ready', function() {
  newTray(state);
  setMenu(state);

  initializeWindow(state, { show: true });
});


function togglePause(state) {
  state.isPaused = !state.isPaused;

  var controlOptions = state.isPaused ? { remove: "resumeTimer", add: "pauseTimer", label: "Resume" }
                                      : { remove: "pauseTimer", add: "resumeTimer", label: "Pause" }

  var newLabel = new MenuItem({
    label: controlOptions.label,
    click: function() {
      togglePause(state)
      dispatchPauseToggle(state)
    }
  });


  delete state.menuItems[controlOptions.remove];
  state.menuItems[controlOptions.add] = newLabel;

  setMenu(state);
}

function initializeWindow(state, options) {
  state.mainWindow = new BrowserWindow({width: 325, height: 475, titleBarStyle: 'hiddenInset'});

  state.mainWindow.loadURL('file://' + __dirname + '/index.html');

  state.mainWindow.on('closed', function() {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    state.mainWindow = null;
  });


  if (options && !options.show) {
    hideWindow(state);
  } else {
    showWindow(state);
  }
};


function showWindow(state) {
  state.isTimerRendered = true;

  state.mainWindow.show();
  state.mainWindow.focus();
  state.menuItems.render.label = "Hide Timer";

  setMenu(state)
};


function hideWindow(state) {
  state.isTimerRendered = false;

  state.mainWindow.hide();
  state.menuItems.render.label = "Timer";
  setMenu(state)
};


function newTray(state) {
  if (state.tray && !state.tray.isDestroyed()) {
    state.tray.destroy();
  }

  state.tray = new Tray(state.menuIcon)
}


function setMenu(state) {
  var menu = new Menu();

  Object.keys(state.menuItems).forEach(function(menuItem) {
    menu.append(state.menuItems[menuItem]);
  });

  state.tray.setContextMenu(menu);
};


function toggleWindow(state) {
  state.mainWindow.isVisible() ? hideWindow(state) : showWindow(state);
};


function updateMenuCircle(state, uri) {
  var resizeOptions = { width: 45, height: 20 }
  var cropRect = { x: -22, y: 0, width: 45, height: 20 }


  var newIcon = nativeImage
                  .createFromDataURL(uri)
                  .resize(resizeOptions)
                  .crop(cropRect)

  state.menuIcon = newIcon

  state.tray.setImage(state.menuIcon);
}



// TODO:
// On launch, launch app in window - still has menu icon
// When window is closed or non-focused - timer menu icon w/ controls
//
//
module.exports = {
  state: state,
  updateMenuCircle: updateMenuCircle,
  togglePause: togglePause
}
