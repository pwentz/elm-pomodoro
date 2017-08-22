module Styles exposing (..)

import Css exposing (..)
import Html exposing (Attribute)
import Html.Attributes


styles cssPairs =
    asPairs cssPairs
        |> Html.Attributes.style


timerContainer : Attribute msg
timerContainer =
    styles
        [ margin auto
        , textAlign center
        ]


filler : Attribute msg
filler =
    styles
        [ height (vh 15)
        ]


icon : Attribute msg
icon =
    styles
        [ color (hex "FFFFFF")
        ]


timer : Attribute msg
timer =
    styles
        [ letterSpacing (pct 10)
        , color (hex "FFFFFF")
        , fontSize (pct 400)
        ]


container : Attribute msg
container =
    styles
        [ height (vh 95)
        ]


breakBackground : Attribute msg
breakBackground =
    styles
        [ backgroundColor (hex "8ACA66")
        ]


pomodoroBackground : Attribute msg
pomodoroBackground =
    styles
        [ backgroundColor (hex "D75849")
        ]


topRightButtonContainer : Attribute msg
topRightButtonContainer =
    styles
        [ float right
        , marginLeft (pct 5)
        ]


pauseContainer : Attribute msg
pauseContainer =
    styles
        [ margin auto
        , marginTop (pct 5)
        , textAlign center
        ]


buttonsContainer : Attribute msg
buttonsContainer =
    styles
        [ paddingTop (vh 5)
        , paddingRight (pct 12)
        ]


settingsLabel : Attribute msg
settingsLabel =
    styles
        [ fontSize (pct 95)
        , color (hex "FFFFFF")
        ]


settingsInputContainer : Attribute msg
settingsInputContainer =
    styles
        [ margin auto
        , textAlign center
        , width (pct 50)
        ]


settingsInput : Attribute msg
settingsInput =
    styles
        [ textAlign center
        , marginTop (pct 5)
        , color (hex "FFFFFF")
        , fontSize (pct 95)
        , height (vh 5)
        , width (pct 20)
        ]


homeButtonContainer : Attribute msg
homeButtonContainer =
    styles
        [ margin auto
        , marginTop (pct 10)
        ]


settingsPomodoroContainer : Attribute msg
settingsPomodoroContainer =
    styles
        [ marginTop (pct 10)
        ]


settingsBreakContainer : Attribute msg
settingsBreakContainer =
    styles
        [ marginTop (pct 10)
        ]
