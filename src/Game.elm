module Game exposing
    ( Game
    , decode
    , getName
    )

import Json.Decode as Decode exposing (Decoder)


type Game
    = Game Details


type alias Details =
    { name : String }


getName : Game -> String
getName (Game { name }) =
    name



-- DECODE


detailsDecoder : Decoder Details
detailsDecoder =
    Decode.map Details <|
        Decode.field "name" Decode.string


decode : Decoder Game
decode =
    Decode.andThen
        (\gameDetails ->
            Decode.succeed <| Game gameDetails
        )
        detailsDecoder
