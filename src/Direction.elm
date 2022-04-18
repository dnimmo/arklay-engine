module Direction exposing
    ( Direction
    , decode
    , getRoomId
    , getText
    , getUsableItems
    , isLocked
    )

import Inventory exposing (Inventory)
import Json.Decode as Decode exposing (Decoder)
import Set


type Direction
    = Direction Details


type alias Details =
    { text : String
    , room : String
    , itemsThatCanBeUsed : List String
    }


getText : Direction -> String
getText (Direction { text }) =
    text


getRoomId : Direction -> String
getRoomId (Direction { room }) =
    room


isLocked : Direction -> Inventory -> Bool
isLocked (Direction { itemsThatCanBeUsed }) inventory =
    not <|
        List.isEmpty itemsThatCanBeUsed
            || List.all
                (Inventory.itemHasBeenUsed inventory)
                itemsThatCanBeUsed


getUsableItems : Direction -> List String
getUsableItems (Direction { itemsThatCanBeUsed }) =
    itemsThatCanBeUsed



-- DECODE


detailsDecoder : Decoder Details
detailsDecoder =
    Decode.map3 Details
        (Decode.field "text" Decode.string)
        (Decode.field "room" Decode.string)
        (Decode.field "itemsThatCanBeUsed" <| Decode.list Decode.string)


decode : Decoder Direction
decode =
    Decode.andThen
        (\details ->
            Decode.succeed <| Direction details
        )
        detailsDecoder
