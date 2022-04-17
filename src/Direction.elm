module Direction exposing
    ( Direction
    , decode
    , getRoomId
    , getText
    )

import Json.Decode as Decode exposing (Decoder)


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
