module View.Game exposing (loadingView, playingView)

import Direction exposing (Direction)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Game exposing (Game)
import Inventory exposing (Inventory)
import Room exposing (Room)
import View.Inventory as InventoryView


loadingView : Element msg
loadingView =
    text "..."


direction :
    { changeRoomMsg : { roomKey : String } -> msg
    , attemptLockedRoomMsg : msg
    }
    -> Inventory
    -> Direction
    -> Element msg
direction { changeRoomMsg, attemptLockedRoomMsg } inventory directionItem =
    let
        isLocked =
            Direction.isLocked directionItem inventory
    in
    Input.button
        [ alpha <|
            if isLocked then
                0.7

            else
                1
        ]
        { onPress =
            Just <|
                if isLocked then
                    attemptLockedRoomMsg

                else
                    changeRoomMsg
                        { roomKey = Direction.getRoomId directionItem
                        }
        , label =
            Element.text <|
                Direction.getText directionItem
        }


type alias PlayingParams msg =
    { game : Game
    , inventory : Inventory
    , currentRoom : Room
    , changeRoomMsg : { roomKey : String } -> msg
    , attemptLockedRoomMsg : msg
    , examineRoomMsg : Room -> msg
    , temporaryMessage : Maybe String
    , useItemMsg : String -> msg
    }


playingView : PlayingParams msg -> Element msg
playingView { game, inventory, currentRoom, changeRoomMsg, attemptLockedRoomMsg, temporaryMessage, examineRoomMsg, useItemMsg } =
    column
        [ Background.color <| rgb255 10 10 10
        , Font.color <| rgb255 250 250 250
        , width fill
        , height fill
        , spacing 50
        ]
        [ text <| Game.getName game
        , text <| Room.getIntro currentRoom
        , text <| Room.getSurroundings currentRoom inventory
        , column [] <|
            List.map
                (direction
                    { changeRoomMsg = changeRoomMsg
                    , attemptLockedRoomMsg = attemptLockedRoomMsg
                    }
                    inventory
                )
            <|
                Room.getAvailableDirections currentRoom
        , Input.button []
            { onPress = Just <| examineRoomMsg currentRoom
            , label = text "Examine room"
            }
        , case temporaryMessage of
            Just str ->
                text str

            Nothing ->
                none
        , InventoryView.view
            { inventory = inventory
            , useItemMsg = useItemMsg
            }
        ]
