module Room exposing
    ( Room
    , decode
    , getAvailableDirections
    , getIntro
    , getSurroundings
    )

import Direction exposing (Direction)
import Json.Decode as Decode exposing (Decoder)


type Room
    = Room Details


type alias Details =
    { name : String
    , intro : String
    , surroundings : String
    , examinationText : String
    , item : Maybe String
    , availableDirections : List Direction
    }


getIntro : Room -> String
getIntro (Room { intro }) =
    intro


getSurroundings : Room -> String
getSurroundings (Room { surroundings }) =
    surroundings


getAvailableDirections : Room -> List Direction
getAvailableDirections (Room { availableDirections }) =
    availableDirections



-- DECODE


detailsDecoder : Decoder Details
detailsDecoder =
    Decode.map6 Details
        (Decode.field "name" Decode.string)
        (Decode.field "intro" Decode.string)
        (Decode.field "surroundings" Decode.string)
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
