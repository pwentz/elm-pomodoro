var electron = require('electron');
var Tray = electron.Tray
var Menu = electron.Menu
var MenuItem = electron.MenuItem
var nativeImage = electron.nativeImage
var BrowserWindow = electron.BrowserWindow;  // Module to create native browser window.
var base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAWCAYAAADEtGw7AAAAAXNSR0IArs4c6QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAAAo1JREFUOBGdlDlolVEQRv8Yk6C4i3ELimTBFQlREYMLgqighUVstLGLhVspohAERSV9SGEsVLBwA1tFQcHGWIipBLUwQXCN4oIx8Zz//RPfEl7QD867987cNzN33vCSpLwqityeJxTZ/vsYgYqTlA1YOYZ3IjbtNTAZfmT7IVZVBd5R8QJtaiS35ALE3srkNwyDgVrAwIOgjsNi6AWDBH7HvQld04yuVqhTzYCd0ADboBr2QS1cgy7og40wBb7DE7gFXyBtmR/5QY9wtiptr8FKZ4HJbI1JtFnZOzCQdxvBBEfhJhToIiefYeB5MAnULuiHeLbrYzgBq0EtgR7Q1waj6mBnK3zeXFgFqgmuwBawqnNgf+9CQQDOqhsGwBjJMvgGB2AFmPUSqN3Qmu7+fjgpzXAK6jOzNmXLDHzMwxl4BtOz9SvrQlD+OMppsZcVHjJ5Z0G21x/yR7yhYS3cg0Vgxe3wBvyBTGIwX2GrlN/R5x17r38YZoJ6CbVemgpemgav4BGoqMKgolwN4owbMJKyTdbAfNA3YmZHxmc9B3+Y6FcEwzSm9Js87q1k7wga660OR2c7fIKz8BOUlY2n6uxCA+tssF229iEkS8GqD3tAvkL+Ree5vAkOwXuIHz8dHZ+0FUJWUy6B/W2CC7AHbIX/KyehQD2cfP7BAmtuzEwS1GR+x3M/tMIG+Ah3YFTOZ6iDzS+4DzvAqsrJKjvBSbgKVaAq44sGjzldz/40rIMX8ACewgD4Iv+UloNVtsAH8P5lULZvKAJrMLh9jmnYzH4vmGAORL/1f4Y+uA3XISYpDcq55Kkm0mk7Qj6vDqzU8fRvsx+cpJB3fHEUFfaS1eqjXyXOPINFxEvyzEnyBwIBioQ36fdtAAAAAElFTkSuQmCC'


// GLOBAL STATE
var state = { isTimerRendered: false }
var app = electron.app;
// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is GCed.
var mainWindow = null;
var menu = new Menu();
var menuItems = {
  render: new MenuItem({
    label: state.isTimerRendered ? "Hide Timer" : "Timer",
    click: toggleWindow
  })
}


// Quit when all windows are closed.
app.on('window-all-closed', function() {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform != 'darwin') {
    app.quit();
  }
});


app.on('ready', function() {
  initializeWindow({ show: false });

  var icon = nativeImage.createFromDataURL(base64Icon);
  var tray = new Tray(icon);

  Object.keys(menuItems).forEach(function(menuItem) {
    menu.append(menuItems[menuItem]);
  });

  tray.setContextMenu(menu);
});

function initializeWindow(options) {
  mainWindow = new BrowserWindow({width: 325, height: 475, titleBarStyle: 'hiddenInset'});

  mainWindow.loadURL('file://' + __dirname + '/index.html');

  mainWindow.on('closed', function() {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });


  if (options && !options.show) {
    hideWindow();
  } else {
    showWindow();
  }
};


function showWindow() {
  state.isTimerRendered = true;

  mainWindow.show();
  mainWindow.focus();
  menuItems.render.label = "Hide Timer";
};


function hideWindow() {
  state.isTimerRendered = false;

  mainWindow.hide();
  menuItems.render.label = "Timer";
};


function toggleWindow() {
  mainWindow.isVisible() ? hideWindow() : showWindow();
};

// TODO:
// On launch, launch app in window - still has menu icon
// When window is closed or non-focused - timer menu icon w/ controls
