port module Ports exposing (..)

import Json.Encode exposing (Value)


type alias ProgressCircleData =
    { time : ( Int, Int )
    , colors : ( String, String )
    }


port initCircle : ProgressCircleData -> Cmd msg


port updateProgressCircle : { current : ( Int, Int ), original : ( Int, Int ) } -> Cmd msg


port timerTransition : ProgressCircleData -> Cmd msg


port togglePause : () -> Cmd msg


port jsError : (Value -> msg) -> Sub msg


port menuBarTogglePause : (Value -> msg) -> Sub msg
