module View.Home exposing (view)

import Element exposing (..)
import Route


view : Element msg
view =
    link []
        { url = Route.toPath Route.ChooseGame
        , label = text "Start"
        }
