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
import Inventory exposing (Inventory)
import Room exposing (Room)
import View.Error as ErrorView
import View.Game as GameView



-- STATE


type State
    = Loading
    | Playing { game : Game, inventory : Inventory, currentRoom : Room }
    | HttpError Http.Error
    | GameError String



-- UPDATE


type Msg
    = GameResultReceieved (Result Http.Error Game)


update : (Msg -> msg) -> Msg -> State -> ( State, Cmd msg )
update on msg state =
    case msg of
        GameResultReceieved (Ok game) ->
            case Game.getStartingRoom game of
                Just startingRoom ->
                    ( Playing
                        { game = game
                        , inventory = Inventory.emptyInventory
                        , currentRoom = startingRoom
                        }
                    , Cmd.none
                    )

                Nothing ->
                    ( GameError <| "Loaded " ++ Game.getName game ++ " successfully, but there is no starting room."
                    , Cmd.none
                    )

        GameResultReceieved (Err err) ->
            ( HttpError err
            , Cmd.none
            )



-- VIEW


view : State -> Element msg
view state =
    case state of
        Loading ->
            GameView.loadingView

        Playing { game, inventory, currentRoom } ->
            GameView.playingView game inventory

        HttpError err ->
            ErrorView.httpErrorView err

        GameError str ->
            ErrorView.view str



-- INIT


init : (Msg -> msg) -> String -> ( State, Cmd msg )
init on gameId =
    ( Loading
    , Game.fetchSpecificGame gameId <| on << GameResultReceieved
    )
