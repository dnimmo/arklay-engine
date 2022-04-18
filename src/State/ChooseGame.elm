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
import View.ChooseGame as ChooseGame
import View.Error as ErrorView



--STATE


type State
    = Loading
    | DisplayingGameList (Dict String Game)
    | Error Http.Error



-- UPDATE


type Msg
    = ReceivedGameInfo (Result Http.Error (Dict String Game))


update : Msg -> State
update msg =
    case msg of
        ReceivedGameInfo (Ok gameDict) ->
            DisplayingGameList gameDict

        ReceivedGameInfo (Err err) ->
            Error err



-- VIEW


view : State -> Element msg
view state =
    case state of
        Loading ->
            ChooseGame.loadingView

        DisplayingGameList gameDict ->
            ChooseGame.view gameDict

        Error err ->
            ErrorView.httpErrorView err



-- INIT


init : (Msg -> msg) -> ( State, Cmd msg )
init on =
    ( Loading
    , Game.fetchGames <| on << ReceivedGameInfo
    )
