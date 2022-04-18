module View.Home exposing (view)

import Element exposing (..)
import Route


view : Element msg
view =
    column
        [ width fill
        , height fill
        ]
        [ paragraph
            [ width (fill |> maximum 1000)
            , centerX
            , padding 50
            ]
            [ el [] <| text "Welcome to Project Arklay. There should probably be some more interesting text here about something, but right now, there's not."
            ]
        , link
            [ centerX
            , centerY
            ]
            { url = Route.toPath Route.ChooseGame
            , label = text "Start"
            }
        ]
