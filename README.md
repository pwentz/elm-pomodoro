## Pomodoro Timer

This app is a simple [pomodoro](https://en.wikipedia.org/wiki/Pomodoro_Technique) timer built in Elm
using Electron.


### Installation

You must have [Electron](https://electron.atom.io) downloaded in order to use this application. The easiest way can be done via npm

```
npm install -g electron
```

You must have the [Elm platform](https://guide.elm-lang.org/install.html) installed as well


### Build

Run the following command to create build of this project

```
elm-make Main.elm --output elm.js
```

Then run the Electron packager with

```
electron .
```

This should launch a development version of the application


### Testing

There are a few tests for the `Timer` data structure. You can run these with the `elm-test` command.
