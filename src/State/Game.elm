module State.Game exposing
    ( Msg
    , State
    , init
    , update
    , view
    )

import Element exposing (Element)
import View.Game as Game



-- STATE


type State
    = State



-- UPDATE


type Msg
    = Msg


update : Msg -> State -> State
update msg state =
    state



-- VIEW


view : State -> Element msg
view state =
    Game.view



-- INIT


init : State
init =
    State
