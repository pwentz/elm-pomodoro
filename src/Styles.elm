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
        [ height (vh 10)
        , width (pct 10)
        ]


timer : Attribute msg
timer =
    styles
        [ letterSpacing (pct 10)
        , color (hex "FFFFFF")
        , fontSize (pct 400)
        ]


breakContainer : Attribute msg
breakContainer =
    styles
        [ backgroundColor (hex "99DA74")
        , height (vh 95)
        ]


defaultContainer : Attribute msg
defaultContainer =
    styles
        [ backgroundColor (hex "D75849")
        , height (vh 95)
        ]


settingsButtonContainer : Attribute msg
settingsButtonContainer =
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
