module Item exposing (Item, decode)

import Json.Decode as Decode exposing (Decoder)


type Item
    = Item Details


type alias Details =
    { name : String
    , description : String
    , messageWhenUsed : String
    , messageWhenUnableToUse : String
    }



-- DECODE


detailsDecoder : Decoder Details
detailsDecoder =
    Decode.map4 Details
        (Decode.field "name" Decode.string)
        (Decode.field "description" Decode.string)
        (Decode.field "messageWhenUsed" Decode.string)
        (Decode.field "messageWhenNotUsed" Decode.string)


decode : Decoder Item
decode =
    Decode.andThen
        (\itemDetails ->
            Decode.succeed <| Item itemDetails
        )
        detailsDecoder
