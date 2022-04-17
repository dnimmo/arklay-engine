module View.Game exposing (loadingView, playingView)

import Direction exposing (Direction)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Game exposing (Game)
import Inventory exposing (Inventory)
import Room exposing (Room)


loadingView : Element msg
loadingView =
    text "..."


type alias PlayingParams msg =
    { game : Game
    , inventory : Inventory
    , currentRoom : Room
    , changeRoomMsg : { roomKey : String } -> msg
    }


direction : ({ roomKey : String } -> msg) -> Direction -> Element msg
direction changeRoomMsg directionItem =
    Input.button []
        { onPress =
            Just <|
                changeRoomMsg
                    { roomKey = Direction.getRoomId directionItem
                    }
        , label =
            Element.text <|
                Direction.getText directionItem
        }


playingView : PlayingParams msg -> Element msg
playingView { game, inventory, currentRoom, changeRoomMsg } =
    column
        [ Background.color <| rgb255 10 10 10
        , Font.color <| rgb255 250 250 250
        , width fill
        , height fill
        ]
        [ text <| Game.getName game
        , text <| Room.getIntro currentRoom
        , text <| Room.getSurroundings currentRoom
        , column [] <| List.map (direction changeRoomMsg) <| Room.getAvailableDirections currentRoom
        ]
