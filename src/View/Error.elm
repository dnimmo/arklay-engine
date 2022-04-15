module View.Error exposing (view)

import Element exposing (..)
import Route


view : String -> Element msg
view str =
    column []
        [ text str
        , link []
            { url = Route.toPath Route.Home
            , label = text "Go back"
            }
        ]
