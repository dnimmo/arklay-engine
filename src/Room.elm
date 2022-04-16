module Room exposing (Room, decode)

import Json.Decode as Decode exposing (Decoder)


type Room
    = Room Details


type alias Direction =
    { text : String
    , room : String
    , itemsThatCanBeUsed : List String
    }


type alias Details =
    { name : String
    , intro : String
    , surroundings : String
    , examinationText : String
    , item : Maybe String
    , availableDirections : List Direction
    }



-- DECODE


directionDecoder : Decoder Direction
directionDecoder =
    Decode.map3 Direction
        (Decode.field "text" Decode.string)
        (Decode.field "room" Decode.string)
        (Decode.field "itemsThatCanBeUsed" <| Decode.list Decode.string)


detailsDecoder : Decoder Details
detailsDecoder =
    Decode.map6 Details
        (Decode.field "name" Decode.string)
        (Decode.field "intro" Decode.string)
        (Decode.field "surroundings" Decode.string)
        (Decode.field "descriptionWhenExamined" Decode.string)
        (Decode.field "item" <| Decode.maybe Decode.string)
        (Decode.field "availableDirections" <| Decode.list directionDecoder)


decode : Decoder Room
decode =
    Decode.andThen
        (\roomDetails ->
            Decode.succeed <| Room roomDetails
        )
        detailsDecoder
