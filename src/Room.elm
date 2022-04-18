module Room exposing
    ( Room
    , decode
    , getAvailableDirections
    , getExaminationText
    , getIntro
    , getMaybeItem
    , getSurroundings
    , itemCanBeUsed
    )

import Direction exposing (Direction)
import Inventory exposing (Inventory)
import Json.Decode as Decode exposing (Decoder)


type Room
    = Room Details


type alias Details =
    { name : String
    , intro : String
    , surroundings : String
    , surroundingsWhenItemPickedUp : Maybe String
    , examinationText : String
    , item : Maybe String
    , availableDirections : List Direction
    }


getIntro : Room -> String
getIntro (Room { intro }) =
    intro


getSurroundings : Room -> Inventory -> String
getSurroundings (Room { surroundings, item, surroundingsWhenItemPickedUp }) inventory =
    case item of
        Just itemId ->
            if Inventory.containsItem inventory itemId then
                Maybe.withDefault surroundings surroundingsWhenItemPickedUp

            else
                surroundings

        Nothing ->
            surroundings


getAvailableDirections : Room -> List Direction
getAvailableDirections (Room { availableDirections }) =
    availableDirections


getExaminationText : Room -> String
getExaminationText (Room { examinationText }) =
    examinationText


getMaybeItem : Room -> Maybe String
getMaybeItem (Room { item }) =
    item


itemCanBeUsed : Room -> String -> Bool
itemCanBeUsed (Room { availableDirections }) itemId =
    availableDirections
        |> List.map Direction.getUsableItems
        |> List.concat
        |> List.member itemId



-- DECODE


detailsDecoder : Decoder Details
detailsDecoder =
    Decode.map7 Details
        (Decode.field "name" Decode.string)
        (Decode.field "intro" Decode.string)
        (Decode.field "surroundings" Decode.string)
        (Decode.field "surroundingsWhenItemPickedUp" <| Decode.maybe Decode.string)
        (Decode.field "descriptionWhenExamined" Decode.string)
        (Decode.field "item" <| Decode.maybe Decode.string)
        (Decode.field "availableDirections" <| Decode.list Direction.decode)


decode : Decoder Room
decode =
    Decode.andThen
        (\roomDetails ->
            Decode.succeed <| Room roomDetails
        )
        detailsDecoder
