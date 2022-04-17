module Game exposing
    ( Game
    , decode
    , fetchGames
    , fetchSpecificGame
    , getName
    , getStartingRoom
    )

import Dict exposing (Dict)
import Http
import Item exposing (Item)
import Json.Decode as Decode exposing (Decoder)
import Room exposing (Room)


type Game
    = Game Details


type alias Details =
    { name : String
    , startingRoom : String
    , rooms : Dict String Room
    , items : Dict String Item
    }


getName : Game -> String
getName (Game { name }) =
    name


getStartingRoom : Game -> Maybe Room
getStartingRoom (Game { rooms, startingRoom }) =
    Dict.get startingRoom rooms



-- DECODE


detailsDecoder : Decoder Details
detailsDecoder =
    Decode.map4 Details
        (Decode.field "name" Decode.string)
        (Decode.field "startingRoom" Decode.string)
        (Decode.field "rooms" <| Decode.dict Room.decode)
        (Decode.field "items" <| Decode.dict Item.decode)


decode : Decoder Game
decode =
    Decode.andThen
        (\gameDetails ->
            Decode.succeed <| Game gameDetails
        )
        detailsDecoder



-- FETCH


gamesEndpoint : String
gamesEndpoint =
    "/games.json"


fetchGames : (Result Http.Error (Dict String Game) -> msg) -> Cmd msg
fetchGames msgOnResult =
    Http.get
        { url = gamesEndpoint
        , expect =
            Http.expectJson
                msgOnResult
            <|
                Decode.dict decode
        }


fetchSpecificGame : String -> (Result Http.Error Game -> msg) -> Cmd msg
fetchSpecificGame gameId msgOnResult =
    Http.get
        { url = gamesEndpoint
        , expect =
            Http.expectJson
                msgOnResult
            <|
                Decode.andThen
                    (\gameDict ->
                        case Dict.get gameId gameDict of
                            Just game ->
                                Decode.succeed game

                            Nothing ->
                                Decode.fail <| "No game found with id of " ++ gameId
                    )
                    (Decode.dict decode)
        }
