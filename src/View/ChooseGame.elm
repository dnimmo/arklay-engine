module View.ChooseGame exposing
    ( loadingView
    , view
    )

import Dict exposing (Dict)
import Element exposing (..)
import Game exposing (Game)
import Route


loadingView : Element msg
loadingView =
    text "Loading"


gameItem : String -> Game -> Element msg
gameItem id game =
    link []
        { url = Route.toPath <| Route.Game id
        , label = text <| Game.getName game
        }


gameList : Dict String Game -> Element msg
gameList gameDict =
    column []
        (gameDict
            |> Dict.toList
            |> List.map
                (\( id, game ) ->
                    gameItem id game
                )
        )


view : Dict String Game -> Element msg
view gameDict =
    column []
        [ text "Choose game"
        , gameList gameDict
        ]
