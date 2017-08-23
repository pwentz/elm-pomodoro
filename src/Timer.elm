module Timer
    exposing
        ( Timer
        , currentTime
        , defaultTime
        , initBreak
        , initPomodoro
        , isBreak
        , isFinished
        , isPomodoro
        , reset
        , tick
        )


type alias Ticker =
    ( Int, Int )


type alias TimeData =
    { current : Ticker
    , default : Ticker
    }


type Timer
    = Break TimeData
    | Pomodoro TimeData


initPomodoro : Int -> Int -> Timer
initPomodoro min sec =
    Pomodoro
        { current = ( min, sec )
        , default = ( min, sec )
        }


initBreak : Int -> Int -> Timer
initBreak min sec =
    Break
        { current = ( min, sec )
        , default = ( min, sec )
        }


isBreak : Timer -> Bool
isBreak timer =
    case timer of
        Break _ ->
            True

        Pomodoro _ ->
            False


isPomodoro : Timer -> Bool
isPomodoro =
    not << isBreak


isFinished : Timer -> Bool
isFinished =
    (==) ( 0, 0 ) << currentTime


defaultTime : Timer -> ( Int, Int )
defaultTime =
    apply .default


currentTime : Timer -> ( Int, Int )
currentTime =
    apply .current


tick : Timer -> Timer
tick =
    let
        decrement data =
            { data
                | current = (decrementClock << .current) data
            }
    in
    map decrement


reset : Timer -> Timer
reset =
    let
        resetCurrent data =
            { data | current = .default data }
    in
    map resetCurrent


decrementClock : Ticker -> Ticker
decrementClock ( hour, min ) =
    if min == 0 then
        ( hour - 1, 59 )
    else
        ( hour, min - 1 )


map : (TimeData -> TimeData) -> Timer -> Timer
map f timer =
    case timer of
        Break timeData ->
            Break (f timeData)

        Pomodoro timeData ->
            Pomodoro (f timeData)


apply : (TimeData -> a) -> Timer -> a
apply f timer =
    case timer of
        Break timeData ->
            f timeData

        Pomodoro timeData ->
            f timeData
