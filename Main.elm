port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (Time)


type alias Settings =
    { pomodoroTime : Int
    , breakTime : Int
    }


type alias Model =
    { currentTime : Time
    , renderedTime : ( Int, Int )
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
            { currentTime = Time.minute
            , renderedTime = ( 0, 10 )
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
        pauseButtonText =
            if .isPaused model then
                "Resume"
            else
                "Pause"

        ( hour, min ) =
            model.renderedTime
    in
    if model.renderSettings then
        renderSettings model
    else
        div
            []
            [ text (toString hour ++ ":" ++ toString min)
            , div
                []
                [ button
                    [ onClick TogglePause ]
                    [ text pauseButtonText ]
                , button
                    [ onClick ToggleSettings ]
                    [ text "Settings" ]
                , p
                    []
                    [ text
                        (if .onBreak model then
                            "Break!"
                         else
                            ""
                        )
                    ]
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
                    | currentTime = time
                    , renderedTime = ( model.settings.breakTime, 0 )
                    , onBreak = True
                  }
                , Cmd.none
                )
            else
                ( { model
                    | currentTime = time
                    , renderedTime = (decrementClock << .renderedTime) model
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


decrementClock : ( Int, Int ) -> ( Int, Int )
decrementClock ( hour, min ) =
    if min == 0 then
        ( hour - 1, 59 )
    else
        ( hour, min - 1 )
