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

        containerStyles =
            if .onBreak model then
                Styles.breakContainer
            else
                Styles.defaultContainer

        ( hour, min ) =
            model.renderedTime
    in
    if model.renderSettings then
        renderSettings model
    else
        div
            [ containerStyles ]
            [ div
                []
                [ div
                    [ Styles.buttonsContainer ]
                    [ div
                        [ Styles.settingsButtonContainer ]
                        [ i
                            [ class "fa fa-sliders fa-2x"
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
                    ]
                    []
                ]
            ]


renderSettings : Model -> Html Msg
renderSettings model =
    div
        []
        [ h1 [] [ text "Settings" ]
        , input
            [ onInput UpdatePomodoro
            , value (toString model.settings.pomodoroTime)
            ]
            []
        , input
            [ onInput UpdateBreak
            , value (toString model.settings.breakTime)
            ]
            []
        , button [ onClick ToggleSettings ] [ text "Home" ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            let
                transitionToBreak =
                    model.renderedTime == ( 0, 1 ) && not model.onBreak
            in
            if transitionToBreak then
                ( { model
                    | renderedTime = ( model.settings.breakTime, 0 )
                    , onBreak = True
                  }
                , Cmd.none
                )
            else
                ( { model
                    | renderedTime = (decrementClock << .renderedTime) model
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
    if .isPaused model then
        Sub.none
    else if .renderedTime model == ( 0, 0 ) then
        Sub.none
    else
        Time.every Time.second Tick


decrementClock : Ticker -> Ticker
decrementClock ( hour, min ) =
    if min == 0 then
        ( hour - 1, 59 )
    else
        ( hour, min - 1 )
