module View.Game exposing (loadingView, playingView)

import Components.Layout as Layout
import Direction exposing (Direction)
import Element exposing (..)
import Element.Input as Input
import Inventory exposing (Inventory)
import Room exposing (Room)
import Set exposing (Set)
import View.Inventory as InventoryView


loadingView : Element msg
loadingView =
    el
        [ centerX
        , centerY
        ]
    <|
        text "..."


decorateDirection : String -> Bool -> String
decorateDirection label visited =
    label
        ++ (if visited then
                " (visited)"

            else
                ""
           )


direction :
    { changeRoomMsg : { roomKey : String } -> msg
    , attemptLockedRoomMsg : msg
    , visitedRooms : Set String
    }
    -> Inventory
    -> Direction
    -> Element msg
direction { changeRoomMsg, attemptLockedRoomMsg, visitedRooms } inventory directionItem =
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
                decorateDirection
                    (Direction.getText directionItem)
                    (Direction.hasBeenVisited directionItem visitedRooms)
        }


type alias PlayingParams msg =
    { inventory : Inventory
    , currentRoom : Room
    , changeRoomMsg : { roomKey : String } -> msg
    , attemptLockedRoomMsg : msg
    , examineRoomMsg : Room -> msg
    , temporaryMessage : Maybe String
    , useItemMsg : String -> msg
    , visitedRooms : Set String
    }


playingView : PlayingParams msg -> Element msg
playingView { inventory, currentRoom, changeRoomMsg, attemptLockedRoomMsg, temporaryMessage, examineRoomMsg, useItemMsg, visitedRooms } =
    column
        [ width fill
        , height fill
        , spacing 50
        , padding 50
        ]
        [ Layout.header <| Room.getName currentRoom
        , paragraph
            []
            [ text <| Room.getIntro currentRoom ]
        , paragraph [ height fill ]
            [ text <| Room.getSurroundings currentRoom inventory ]
        , el [ height fill ] none
        , wrappedRow
            [ height fill
            , width fill
            , spacing 50
            ]
            [ column
                [ height fill
                , width fill
                , spacing 20
                ]
              <|
                Layout.header "Directions"
                    :: (List.map
                            (direction
                                { changeRoomMsg = changeRoomMsg
                                , attemptLockedRoomMsg = attemptLockedRoomMsg
                                , visitedRooms = visitedRooms
                                }
                                inventory
                            )
                        <|
                            Room.getAvailableDirections currentRoom
                       )
            , column
                [ width fill
                , height fill
                , spacing 20
                ]
                [ Layout.header "Examine"
                , Input.button []
                    { onPress = Just <| examineRoomMsg currentRoom
                    , label = text "Examine room"
                    }
                , case temporaryMessage of
                    Just str ->
                        paragraph
                            [ width fill ]
                            [ text str ]

                    Nothing ->
                        none
                ]
            , InventoryView.view
                { inventory = inventory
                , useItemMsg = useItemMsg
                }
            ]
        ]
