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
import Item
import Room exposing (Room)
import View.Error as ErrorView
import View.Game as GameView



-- STATE


type State
    = Loading
    | Playing
        { game : Game
        , inventory : Inventory
        , currentRoom : Room
        , temporaryMessage : Maybe String
        }
    | HttpError Http.Error
    | GameError String



-- UPDATE


type Msg
    = GameResultReceieved (Result Http.Error Game)
    | ChangeRoom { roomKey : String }
    | AttemptToEnterLockedRoom
    | AttemptToUseItem String
    | ExamineRoom Room


playingStateError : String -> State
playingStateError str =
    GameError <| "Unable to process " ++ str ++ " message - not in Playing state"


handleRoomChange : State -> String -> State
handleRoomChange state roomKey =
    case state of
        Playing ({ game } as gameDetails) ->
            case Game.getRoom game roomKey of
                Just newRoom ->
                    Playing
                        { gameDetails
                            | currentRoom = newRoom
                            , temporaryMessage = Nothing
                        }

                Nothing ->
                    GameError <| "No room matching given key: " ++ roomKey

        _ ->
            playingStateError "room change"


handleAttemptToEnterLockedRoom : State -> State
handleAttemptToEnterLockedRoom state =
    case state of
        Playing gameDetails ->
            Playing
                { gameDetails
                    | temporaryMessage = Just "Seems I can't go this way yet..."
                }

        _ ->
            playingStateError "attempt to enter locked room"


handleExamineRoom : State -> Room -> State
handleExamineRoom state room =
    case state of
        Playing ({ game, inventory } as gameDetails) ->
            case Room.getMaybeItem room of
                Just itemId ->
                    case Game.getItem game itemId of
                        Just item ->
                            Playing <|
                                if Inventory.containsItem inventory itemId then
                                    { gameDetails
                                        | inventory = Inventory.addItem gameDetails.inventory itemId item
                                        , temporaryMessage =
                                            Just <| Room.getExaminationText room
                                    }

                                else
                                    { gameDetails
                                        | inventory = Inventory.addItem gameDetails.inventory itemId item
                                        , temporaryMessage =
                                            Just <| Item.getName item ++ " added to inventory"
                                    }

                        Nothing ->
                            GameError <| "No item exists with ID of " ++ itemId

                Nothing ->
                    Playing
                        { gameDetails
                            | temporaryMessage =
                                Just <| Room.getExaminationText room
                        }

        _ ->
            playingStateError "examine room"


handleAttemptToUseItem : State -> String -> State
handleAttemptToUseItem state itemId =
    case state of
        Playing ({ inventory, currentRoom } as gameDetails) ->
            case Inventory.getItem inventory itemId of
                Just item ->
                    if Room.itemCanBeUsed currentRoom itemId then
                        Playing
                            { gameDetails
                                | inventory = Inventory.useItem inventory itemId
                                , temporaryMessage =
                                    Just <| Item.getMessageWhenUsed item
                            }

                    else
                        Playing
                            { gameDetails
                                | temporaryMessage =
                                    Just <| Item.getMessageWhenUnableToUse item
                            }

                Nothing ->
                    GameError <| "No item exists in inventory for key " ++ itemId

        _ ->
            playingStateError "attempt to use item"


update : Msg -> State -> ( State, Cmd msg )
update msg state =
    case msg of
        GameResultReceieved (Ok game) ->
            case Game.getStartingRoom game of
                Just startingRoom ->
                    ( Playing
                        { game = game
                        , inventory = Inventory.emptyInventory
                        , currentRoom = startingRoom
                        , temporaryMessage = Nothing
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

        AttemptToEnterLockedRoom ->
            ( handleAttemptToEnterLockedRoom state
            , Cmd.none
            )

        ExamineRoom room ->
            ( handleExamineRoom state room
            , Cmd.none
            )

        AttemptToUseItem item ->
            ( handleAttemptToUseItem state item
            , Cmd.none
            )



-- VIEW


view : (Msg -> msg) -> State -> Element msg
view on state =
    case state of
        Loading ->
            GameView.loadingView

        Playing { game, inventory, currentRoom, temporaryMessage } ->
            GameView.playingView
                { game = game
                , inventory = inventory
                , currentRoom = currentRoom
                , changeRoomMsg = on << ChangeRoom
                , attemptLockedRoomMsg = on AttemptToEnterLockedRoom
                , temporaryMessage = temporaryMessage
                , examineRoomMsg = on << ExamineRoom
                , useItemMsg = on << AttemptToUseItem
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
