module View.NotFound exposing (view)

import Element exposing (..)
import Route


view : Element msg
view =
    column []
        [ text "Page not found"
        , link []
            { url = Route.toPath Route.Home
            , label = text "Go back"
            }
        ]
