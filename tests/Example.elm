module Example exposing (..)

import Expect
import Game exposing (Game)
import Json.Decode as Decode
import Test exposing (..)


testGameString : String
testGameString =
    """
    {
    \t"name": "Test game",
    \t"startingRoom": "TEST_START",
    \t"rooms": {
    \t\t"TEST_START": {
    \t\t\t"name": "Test starting room",
    \t\t\t"intro": "Test intro",
    \t\t\t"surroundings": "Test surroundings",
    \t\t\t"surroundingsWhenItemPickedUp": null,
    \t\t\t"surroundingsWhenItemUsed": null,
    \t\t\t"item": "TEST_ITEM",
    \t\t\t"availableDirections": [],
    \t\t\t"descriptionWhenExamined": "Test description"
    \t\t}
    \t},
    \t"items": {
    \t\t"TEST_ITEM": {
    \t\t\t"name": "Test item",
    \t\t\t"description": "Test item description",
    \t\t\t"messageWhenUsed": "Message when used",
    \t\t\t"messageWhenNotUsed": "Message when not used"
    \t\t}
    \t}
    }
    """


testGame : Result Decode.Error Game
testGame =
    Decode.decodeString Game.decode testGameString


suite : Test
suite =
    case testGame of
        Ok game ->
            describe "Game"
                [ test "can get a game's name" <|
                    \_ ->
                        Expect.equal
                            (Game.getName game)
                            "Test game"
                ]

        Err err ->
            test "Could not decode game" <|
                \_ ->
                    Expect.equal
                        (Decode.errorToString err)
                        "This is only here to ensure a useful message if decoding fails"
