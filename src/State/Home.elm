module State.Home exposing
    ( State
    , init
    , view
    )

import Element exposing (Element)
import View.Home as Home



-- STATE


type State
    = State



-- VIEW


view : State -> Element msg
view state =
    Home.view



-- INIT


init : State
init =
    State
