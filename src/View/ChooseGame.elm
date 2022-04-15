module View.ChooseGame exposing
    ( errorView
    , loadingView
    , view
    )

import Dict exposing (Dict)
import Element exposing (..)
import Game exposing (Game)


loadingView : Element msg
loadingView =
    text "Loading"


gameItem : Game -> Element msg
gameItem =
    el []
        << text
        << Game.getName


gameList : Dict String Game -> Element msg
gameList gameDict =
    column []
        (gameDict
            |> Dict.toList
            |> List.map
                (\( _, game ) ->
                    gameItem game
                )
        )


view : Dict String Game -> Element msg
view gameDict =
    column []
        [ text "Choose game"
        , gameList gameDict
        ]


errorView : String -> Element msg
errorView str =
    text str
