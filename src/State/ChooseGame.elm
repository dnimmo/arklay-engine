module State.ChooseGame exposing
    ( Msg
    , State
    , init
    , update
    , view
    )

import Dict exposing (Dict)
import Element exposing (Element)
import Game exposing (Game)
import Http
import Json.Decode as Decode
import View.ChooseGame as ChooseGame



--STATE


type State
    = Loading
    | DisplayingGameList (Dict String Game)
    | Error String



-- UPDATE


type Msg
    = ReceivedGameInfo (Result Http.Error (Dict String Game))


update : Msg -> State -> State
update msg state =
    case msg of
        ReceivedGameInfo (Ok gameDict) ->
            DisplayingGameList gameDict

        ReceivedGameInfo (Err err) ->
            Error <|
                "Please accept our apologies, something has gone wrong. "
                    ++ (case err of
                            Http.BadUrl str ->
                                "There was a problem with the URL requested: " ++ str

                            Http.Timeout ->
                                "The request timed out. Please check your connection and try again."

                            Http.NetworkError ->
                                "There seems to be a problem with your connection. Please check your connection and try again."

                            Http.BadStatus int ->
                                "Received status: " ++ String.fromInt int

                            Http.BadBody str ->
                                str
                       )



-- VIEW


view : State -> Element msg
view state =
    case state of
        Loading ->
            ChooseGame.loadingView

        DisplayingGameList gameDict ->
            ChooseGame.view gameDict

        Error str ->
            ChooseGame.errorView str



-- INIT


init : (Msg -> msg) -> ( State, Cmd msg )
init on =
    ( Loading
    , Http.get
        { url = "/games.json"
        , expect =
            Http.expectJson
                (on << ReceivedGameInfo)
            <|
                Decode.dict Game.decode
        }
    )
