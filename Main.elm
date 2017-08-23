module Main exposing (..)

import Css
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Json.Encode exposing (Value)
import Styles
import Time exposing (Time)
import Timer exposing (Timer)


port initCircle : ( Int, Int ) -> Cmd msg


port updateProgressCircle : { current : ( Int, Int ), original : ( Int, Int ) } -> Cmd msg


port jsError : (Value -> msg) -> Sub msg


type alias Model =
    { timers : ( Timer, Timer )
    , isPaused : Bool
    , renderSettings : Bool
    , error : Maybe String
    , cycles : Int
    }


type Msg
    = Tick
    | TogglePause
    | ToggleSettings
    | UpdateTimer Timer String
    | Transition
    | JsError (Result String String)
    | ClearCycles


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions =
            \model ->
                Sub.batch
                    [ subscribeToTick model
                    , jsError (JsError << Json.decodeValue Json.string)
                    ]
        }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { timers = ( Timer.initPomodoro 0 3, Timer.initBreak 0 3 )
            , isPaused = False
            , renderSettings = False
            , error = Nothing
            , cycles = 0
            }
    in
    ( model, initCircle ( 0, 10 ) )


view : Model -> Html Msg
view model =
    let
        color =
            if (Timer.isBreak << currentTimer) model then
                Styles.green
            else
                Styles.red

        ( timerStyles, settingsStyles ) =
            if .renderSettings model then
                ( Styles.hide, Styles.show )
            else
                ( Styles.show, Styles.hide )

        toRender model =
            .error model
                |> Maybe.map (\err -> [ p [] [ text err ] ])
                |> Maybe.withDefault
                    [ div
                        [ timerStyles ]
                        [ timerView model color ]
                    , div
                        [ settingsStyles ]
                        [ renderSettings model color ]
                    ]
    in
    div
        []
        (toRender model)


timerView : Model -> Attribute Msg -> Html Msg
timerView model color =
    let
        cycles =
            .cycles model
                |> List.range 1
                |> List.map
                    (\_ ->
                        i
                            [ class "fa fa-check-circle"
                            , Styles.cycleIcon
                            ]
                            []
                    )

        iconBelowTimer =
            if .isPaused model then
                "fa fa-play fa-2x"
            else
                "fa fa-pause fa-2x"

        ( hour, min ) =
            (Timer.currentTime << currentTimer) model
    in
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
            [ Styles.timerContainer
            , id "timer-container"
            ]
            []
        , div
            [ Styles.pauseContainer ]
            [ i
                [ onClick TogglePause
                , class iconBelowTimer
                , Styles.withColor color
                ]
                []
            ]
        , div
            [ Styles.cyclesContainer ]
            cycles
        ]


renderSettings : Model -> Css.Color -> Html Msg
renderSettings model color =
    let
        breakTimer =
            .timers model
                |> fetchBy Timer.isBreak

        pomodoroTimer =
            .timers model
                |> fetchBy Timer.isPomodoro
    in
    div
        []
        [ div
            [ Styles.buttonsContainer ]
            [ div
                [ Styles.topRightButtonContainer ]
                [ i
                    [ class "fa fa-clock-o fa-2x"
                    , onClick ToggleSettings
                    ]
                    []
                ]
            ]
        , div [ Styles.filler ] []
        , div
            [ Styles.settingsInputsWrapper ]
            [ div
                [ Styles.settingsInputContainer ]
                [ label
                    [ for "pomodoro-time"
                    , Styles.settingsLabel color
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
                    , Styles.settingsInput color
                    ]
                    []
                ]
            , br [] []
            , div
                [ Styles.settingsInputContainer ]
                [ label
                    [ for "break-time"
                    , Styles.settingsLabel color
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
                    , Styles.settingsInput color
                    ]
                    []
                ]
            , div
                [ Styles.clearCyclesContainer ]
                [ label
                    [ for "clear-cycles"
                    , Styles.settingsLabel color
                    ]
                    [ text "Clear Cycles" ]
                , br [] []
                , i
                    [ Styles.clearCyclesIcon
                    , class "fa fa-ban"
                    , onClick ClearCycles
                    ]
                    []
                ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick ->
            let
                (( curr, _ ) as newTimers) =
                    (Tuple.mapFirst Timer.tick << .timers) model
            in
            ( { model
                | timers = newTimers
              }
            , updateProgressCircle
                { current = Timer.currentTime curr
                , original = Timer.defaultTime curr
                }
            )

        Transition ->
            let
                cycles =
                    if (Timer.isBreak << currentTimer) model then
                        ((+) 1 << .cycles) model
                    else
                        .cycles model
            in
            ( { model
                | timers = (rotateTimer << .timers) model
                , cycles = cycles
              }
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

        JsError res ->
            let
                errMsg =
                    res
                        |> Result.withDefault "Something went wrong while parsing an error!"
            in
            ( { model | error = Just errMsg }, Cmd.none )

        ClearCycles ->
            ( { model
                | cycles = 0
                , renderSettings = False
              }
            , Cmd.none
            )


subscribeToTick : Model -> Sub Msg
subscribeToTick model =
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
