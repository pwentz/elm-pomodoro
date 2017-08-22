port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Styles
import Time exposing (Time)


type alias Ticker =
    ( Int, Int )


type alias Settings =
    { pomodoroTime : Int
    , breakTime : Int
    }


type alias Model =
    { renderedTime : Ticker
    , isPaused : Bool
    , renderSettings : Bool
    , onBreak : Bool
    , settings : Settings
    }


type Msg
    = Tick Time
    | TogglePause
    | ToggleSettings
    | UpdatePomodoro String
    | UpdateBreak String
    | Transition


port renderMe : Model -> Cmd msg


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


defaultSettings : Settings
defaultSettings =
    Settings 45 10


init : ( Model, Cmd Msg )
init =
    let
        model =
            { renderedTime = ( 0, 10 )
            , isPaused = False
            , renderSettings = False
            , onBreak = False
            , settings = defaultSettings
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
            if .onBreak model then
                Styles.breakBackground
            else
                Styles.pomodoroBackground

        ( hour, min ) =
            model.renderedTime
    in
    if model.renderSettings then
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
                    [ onInput UpdatePomodoro
                    , value (toString model.settings.pomodoroTime)
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
                    [ onInput UpdateBreak
                    , value (toString model.settings.breakTime)
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
        Tick time ->
            ( { model
                | renderedTime = (decrementClock << .renderedTime) model
              }
            , Cmd.none
            )

        Transition ->
            let
                newTime =
                    if .onBreak model then
                        model.settings.pomodoroTime
                    else
                        model.settings.breakTime
            in
            ( { model
                | renderedTime = ( newTime, 0 )
                , onBreak = (not << .onBreak) model
              }
            , Cmd.none
            )

        TogglePause ->
            ( { model | isPaused = (not << .isPaused) model }, Cmd.none )

        ToggleSettings ->
            ( { model | renderSettings = (not << .renderSettings) model }, Cmd.none )

        UpdatePomodoro input ->
            let
                settings =
                    model.settings

                newTime =
                    input
                        |> String.toInt
                        |> Result.withDefault 0
            in
            if .onBreak model then
                ( { model
                    | settings = { settings | pomodoroTime = newTime }
                  }
                , Cmd.none
                )
            else
                ( { model
                    | renderedTime = ( newTime, 0 )
                    , settings = { settings | pomodoroTime = newTime }
                  }
                , Cmd.none
                )

        UpdateBreak input ->
            let
                settings =
                    model.settings

                newTime =
                    input
                        |> String.toInt
                        |> Result.withDefault 0
            in
            if .onBreak model then
                ( { model
                    | renderedTime = ( newTime, 0 )
                    , settings = { settings | breakTime = newTime }
                  }
                , Cmd.none
                )
            else
                ( { model
                    | settings = { settings | breakTime = newTime }
                  }
                , Cmd.none
                )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        sub =
            if .renderedTime model == ( 0, 0 ) then
                \_ -> Transition
            else
                Tick
    in
    if .isPaused model then
        Sub.none
    else
        Time.every Time.second sub


decrementClock : Ticker -> Ticker
decrementClock ( hour, min ) =
    if min == 0 then
        ( hour - 1, 59 )
    else
        ( hour, min - 1 )
