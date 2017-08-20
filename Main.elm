port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Time exposing (Time)


type alias Model =
    { currentTime : Time
    , renderedTime : ( Int, Int )
    , isPaused : Bool
    }


type Msg
    = Tick Time
    | Pause


port renderMe : Model -> Cmd msg


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
            { currentTime = Time.minute
            , renderedTime = ( 0, 50 )
            , isPaused = False
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
    div
        []
        [ text (toString hour ++ ":" ++ toString min)
        , div
            []
            [ button
                [ onClick Pause ]
                [ text pauseButtonText ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( { model
                | currentTime = time
                , renderedTime = (decrementClock << .renderedTime) model
              }
            , Cmd.none
            )

        Pause ->
            ( { model | isPaused = (not << .isPaused) model }, Cmd.none )


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
