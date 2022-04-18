module View.ChooseGame exposing
    ( loadingView
    , view
    )

import Dict exposing (Dict)
import Element exposing (..)
import Element.Border as Border
import Game exposing (Game)
import Route


loadingView : Element msg
loadingView =
    el
        [ centerX
        , centerY
        ]
    <|
        text "..."


gameItem : String -> Game -> Element msg
gameItem id game =
    link
        [ centerX
        , paddingXY 50 20
        , Border.width 1
        , Border.rounded 5
        ]
        { url = Route.toPath <| Route.Game id
        , label = text <| Game.getName game
        }


gameList : Dict String Game -> Element msg
gameList gameDict =
    column
        [ width fill
        , height fill
        , paddingXY 0 50
        ]
        (gameDict
            |> Dict.toList
            |> List.map
                (\( id, game ) ->
                    gameItem id game
                )
        )


view : Dict String Game -> Element msg
view gameDict =
    column
        [ width fill
        , height fill
        , padding 50
        ]
        [ el [ centerX ] <| text "Choose a game"
        , gameList gameDict
        ]
