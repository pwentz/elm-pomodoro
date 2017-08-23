module TimerTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Timer exposing (..)


suite : Test
suite =
    describe "Timer"
        [ describe "tick"
            [ test "it removes one second from the given timer's current time" <|
                \_ ->
                    initBreak 5 10
                        |> tick
                        |> currentTime
                        |> Expect.equal ( 5, 9 )
            , test "it decrements the minute if the second is at 0" <|
                \_ ->
                    initBreak 5 0
                        |> tick
                        |> currentTime
                        |> Expect.equal ( 4, 59 )
            ]
        , describe "defaultTime"
            [ test "it gets the default time of a given timer" <|
                \_ ->
                    initPomodoro 20 11
                        |> defaultTime
                        |> Expect.equal ( 20, 11 )
            ]
        , describe "isBreak"
            [ test "it returns True if timer is Break timer" <|
                \_ ->
                    initBreak 0 0
                        |> isBreak
                        |> Expect.equal True
            , test "it returns False if timer is not Break timer" <|
                \_ ->
                    initPomodoro 0 0
                        |> isBreak
                        |> Expect.equal False
            ]
        , describe "isPomodoro"
            [ test "it returns True if timer is Pomodoro timer" <|
                \_ ->
                    initPomodoro 0 0
                        |> isPomodoro
                        |> Expect.equal True
            , test "it returns False if timer is not Pomodoro timer" <|
                \_ ->
                    initBreak 0 0
                        |> isPomodoro
                        |> Expect.equal False
            ]
        , describe "isFinished"
            [ test "it returns True if timer's current time is at 0:00" <|
                \_ ->
                    initBreak 0 1
                        |> tick
                        |> isFinished
                        |> Expect.equal True
            , test "it returns False if timer's current time is anything else" <|
                \_ ->
                    initBreak 0 1
                        |> isFinished
                        |> Expect.equal False
            ]
        , describe "reset"
            [ test "it updates a timer's current time to match it's default time" <|
                \_ ->
                    initBreak 2 30
                        |> (tick << tick << tick << tick << tick)
                        |> reset
                        |> currentTime
                        |> Expect.equal ( 2, 30 )
            ]
        ]
