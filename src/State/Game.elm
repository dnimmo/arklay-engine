module State.Game exposing
    ( Msg
    , State
    , init
    , update
    , view
    )

import Element exposing (Element)
import Game exposing (Game)
import Http
import View.Error as ErrorView
import View.Game as GameView



-- STATE


type State
    = Loading
    | Playing Game
    | Error Http.Error



-- UPDATE


type Msg
    = GameResultReceieved (Result Http.Error Game)


update : (Msg -> msg) -> Msg -> State -> ( State, Cmd msg )
update on msg state =
    case msg of
        GameResultReceieved (Ok game) ->
            ( Playing game
            , Cmd.none
            )

        GameResultReceieved (Err err) ->
            ( Error err
            , Cmd.none
            )



-- VIEW


view : State -> Element msg
view state =
    case state of
        Loading ->
            GameView.loadingView

        Playing game ->
            GameView.view game

        Error err ->
            ErrorView.httpErrorView err



-- INIT


init : (Msg -> msg) -> String -> ( State, Cmd msg )
init on gameId =
    ( Loading
    , Game.fetchSpecificGame gameId <| on << GameResultReceieved
    )
