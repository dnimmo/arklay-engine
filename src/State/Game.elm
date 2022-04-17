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
    | ChangeRoom { roomKey : String }


handleRoomChange : State -> String -> State
handleRoomChange state roomKey =
    case state of
        Playing ({ game } as gameDetails) ->
            case Game.getRoom game roomKey of
                Just newRoom ->
                    Playing { gameDetails | currentRoom = newRoom }

                Nothing ->
                    GameError <| "No room matching given key: " ++ roomKey

        _ ->
            GameError "Unable to process room change message - not in Playing state"


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

        ChangeRoom { roomKey } ->
            ( handleRoomChange state roomKey
            , Cmd.none
            )



-- VIEW


view : (Msg -> msg) -> State -> Element msg
view on state =
    case state of
        Loading ->
            GameView.loadingView

        Playing { game, inventory, currentRoom } ->
            GameView.playingView
                { game = game
                , inventory = inventory
                , currentRoom = currentRoom
                , changeRoomMsg = on << ChangeRoom
                }

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
