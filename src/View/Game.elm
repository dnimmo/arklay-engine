module View.Game exposing (loadingView, view)

import Element exposing (..)
import Game exposing (Game)


loadingView : Element msg
loadingView =
    text "Loading"


view : Game -> Element msg
view game =
    text <| Game.getName game
