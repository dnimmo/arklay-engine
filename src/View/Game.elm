module View.Game exposing (loadingView, playingView)

import Element exposing (..)
import Game exposing (Game)
import Inventory exposing (Inventory)


loadingView : Element msg
loadingView =
    text "Loading"


playingView : Game -> Inventory -> Element msg
playingView game inventory =
    text <| Game.getName game
