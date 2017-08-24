module Styles exposing (..)

import Css exposing (..)
import Html exposing (Attribute)
import Html.Attributes


styles cssPairs =
    asPairs cssPairs
        |> Html.Attributes.style


lightGreen =
    "DBF5CC"


green =
    "8ACA66"


lightRed =
    "F9CCC6"


red =
    "D75849"


grey =
    "E9EAE8"


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


withColor : String -> Attribute msg
withColor color =
    styles
        [ Css.color (hex color)
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
        , marginTop (pct 10)
        , textAlign center
        ]


buttonsContainer : Attribute msg
buttonsContainer =
    styles
        [ paddingTop (vh 5)
        , paddingRight (pct 12)
        ]


settingsLabel : String -> Attribute msg
settingsLabel color =
    styles
        [ fontSize (pct 95)
        , Css.color (hex color)
        ]


settingsInputsWrapper : Attribute msg
settingsInputsWrapper =
    styles
        [ margin auto
        , textAlign center
        , width (pct 50)
        ]


settingsInput : String -> Attribute msg
settingsInput color =
    styles
        [ textAlign center
        , marginTop (pct 5)
        , Css.color (hex color)
        , fontSize (pct 95)
        , height (vh 5)
        , width (pct 20)
        , backgroundColor (hex grey)
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
        , color (hex green)
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
