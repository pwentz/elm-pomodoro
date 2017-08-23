port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Styles
import Time exposing (Time)
import Timer exposing (Timer)


type alias Model =
    { timers : ( Timer, Timer )
    , isPaused : Bool
    , renderSettings : Bool
    }


type Msg
    = Tick
    | TogglePause
    | ToggleSettings
    | UpdateTimer Timer String
    | Transition


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { timers = ( Timer.initPomodoro 0 10, Timer.initBreak 0 10 )
            , isPaused = False
            , renderSettings = False
            }
    in
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        iconBelowTimer =
            if .isPaused model then
                "fa fa-play fa-2x"
            else
                "fa fa-pause fa-2x"

        backgroundStyles =
            if (Timer.isBreak << currentTimer) model then
                Styles.breakBackground
            else
                Styles.pomodoroBackground

        ( hour, min ) =
            (Timer.currentTime << currentTimer) model
    in
    if .renderSettings model then
        renderSettings model backgroundStyles
    else
        div
            [ backgroundStyles
            , Styles.container
            ]
            [ div
                []
                [ div
                    [ Styles.buttonsContainer ]
                    [ div
                        [ Styles.topRightButtonContainer ]
                        [ i
                            [ class "fa fa-cogs fa-2x"
                            , Styles.icon
                            , onClick ToggleSettings
                            ]
                            []
                        ]
                    ]
                ]
            , div [ Styles.filler ] []
            , div
                [ Styles.timerContainer ]
                [ h2
                    [ Styles.timer ]
                    [ text (toString hour ++ ":" ++ toString min) ]
                ]
            , div
                [ Styles.pauseContainer ]
                [ i
                    [ onClick TogglePause
                    , class iconBelowTimer
                    , Styles.icon
                    ]
                    []
                ]
            ]


renderSettings : Model -> Attribute Msg -> Html Msg
renderSettings model backgroundStyle =
    let
        breakTimer =
            .timers model
                |> fetchBy Timer.isBreak

        pomodoroTimer =
            .timers model
                |> fetchBy Timer.isPomodoro
    in
    div
        [ backgroundStyle
        , Styles.container
        ]
        [ div
            [ Styles.buttonsContainer ]
            [ div
                [ Styles.topRightButtonContainer ]
                [ i
                    [ class "fa fa-clock-o fa-2x"
                    , onClick ToggleSettings
                    , Styles.icon
                    ]
                    []
                ]
            ]
        , div [ Styles.filler ] []
        , div
            [ Styles.settingsInputContainer ]
            [ div
                [ Styles.settingsPomodoroContainer ]
                [ label
                    [ for "pomodoro-time"
                    , Styles.settingsLabel
                    ]
                    [ text "Pomodoro Time" ]
                , br [] []
                , input
                    [ onInput (UpdateTimer pomodoroTimer)
                    , value
                        (toString <|
                            (Tuple.first << Timer.defaultTime) pomodoroTimer
                        )
                    , name "pomodoro-time"
                    , Styles.settingsInput
                    , backgroundStyle
                    ]
                    []
                ]
            , br [] []
            , div
                [ Styles.settingsBreakContainer ]
                [ label
                    [ for "break-time"
                    , Styles.settingsLabel
                    ]
                    [ text "Break Time" ]
                , br [] []
                , input
                    [ onInput (UpdateTimer breakTimer)
                    , value
                        (toString <|
                            (Tuple.first << Timer.defaultTime) breakTimer
                        )
                    , name "break-time"
                    , Styles.settingsInput
                    , backgroundStyle
                    ]
                    []
                ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ->
            ( { model
                | timers = (Tuple.mapFirst Timer.tick << .timers) model
              }
            , Cmd.none
            )

        Transition ->
            ( { model | timers = (rotateTimer << .timers) model }
            , Cmd.none
            )

        TogglePause ->
            ( { model | isPaused = (not << .isPaused) model }, Cmd.none )

        ToggleSettings ->
            ( { model | renderSettings = (not << .renderSettings) model }, Cmd.none )

        UpdateTimer timer input ->
            let
                init =
                    if Timer.isBreak timer then
                        Timer.initBreak
                    else
                        Timer.initPomodoro
            in
            ( { model
                | timers =
                    replaceTimer
                        timer
                        (init (timeFromString input) 0)
                        (.timers model)
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        msg =
            if Timer.isFinished (currentTimer model) then
                Transition
            else
                Tick
    in
    if .isPaused model then
        Sub.none
    else
        Time.every Time.second (\_ -> msg)


rotateTimer : ( Timer, Timer ) -> ( Timer, Timer )
rotateTimer ( curr, next ) =
    ( next, Timer.reset curr )


replaceTimer : Timer -> Timer -> ( Timer, Timer ) -> ( Timer, Timer )
replaceTimer old new ( current, next ) =
    if old == current then
        ( new, next )
    else
        ( current, new )


fetchBy : (a -> Bool) -> ( a, a ) -> a
fetchBy pred ( curr, next ) =
    if pred curr then
        curr
    else
        next


timeFromString : String -> Int
timeFromString =
    Result.withDefault 0 << String.toInt


currentTimer : Model -> Timer
currentTimer =
    Tuple.first << .timers
