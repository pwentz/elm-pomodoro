module Styles exposing (..)

import Css exposing (..)
import Html exposing (Attribute)
import Html.Attributes


styles cssPairs =
    asPairs cssPairs
        |> Html.Attributes.style


green =
    hex "8ACA66"


red =
    hex "D75849"


grey =
    hex "E9EAE8"


timerContainer : Attribute msg
timerContainer =
    styles
        [ margin auto
        , textAlign center
        , width (pct 65)
        ]


filler : Attribute msg
filler =
    styles
        [ height (vh 15)
        ]


withColor : Color -> Attribute msg
withColor color =
    styles
        [ Css.color color
        ]


timer : Color -> Attribute msg
timer color =
    styles
        [ letterSpacing (pct 10)
        , Css.color color
        , fontSize (pct 400)
        ]


container : Attribute msg
container =
    styles
        [ height (vh 95)
        , backgroundColor grey
        ]


breakBackground : Attribute msg
breakBackground =
    styles
        [ backgroundColor (hex "")
        ]


pomodoroBackground : Attribute msg
pomodoroBackground =
    styles
        [ backgroundColor (hex "")
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


settingsLabel : Color -> Attribute msg
settingsLabel color =
    styles
        [ fontSize (pct 95)
        , Css.color color
        ]


settingsInputsWrapper : Attribute msg
settingsInputsWrapper =
    styles
        [ margin auto
        , textAlign center
        , width (pct 50)
        ]


settingsInput : Color -> Attribute msg
settingsInput color =
    styles
        [ textAlign center
        , marginTop (pct 5)
        , Css.color color
        , fontSize (pct 95)
        , height (vh 5)
        , width (pct 20)
        , backgroundColor grey
        ]


homeButtonContainer : Attribute msg
homeButtonContainer =
    styles
        [ margin auto
        , marginTop (pct 10)
        ]


settingsInputContainer : Attribute msg
settingsInputContainer =
    styles
        [ marginTop (pct 10)
        ]


cycleIcon : Attribute msg
cycleIcon =
    styles
        [ marginRight (pct 2)
        ]


cyclesContainer : Attribute msg
cyclesContainer =
    styles
        [ margin auto
        , marginTop (pct 10)
        , width (pct 50)
        , color green
        ]


clearCyclesIcon : Attribute msg
clearCyclesIcon =
    styles
        [ marginTop (pct 5)
        ]


clearCyclesContainer : Attribute msg
clearCyclesContainer =
    styles
        [ marginTop (pct 20)
        ]


hide : Attribute msg
hide =
    styles
        [ display none
        ]


show : Attribute msg
show =
    styles
        [ display block
        ]
