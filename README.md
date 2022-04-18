# arklay-engine

I've written this project in many different technologies, and I tend to rebuild it every couple of years just for the sake of comparison (and my own enjoyment). Usually in the form of a text-adventure game, but this time in the form of an engine for processing text-adventure games.

## Overview / Development

### State machines

Anything with its own `update` function, `State`, and `Msg` types is what I mean when I say "State machine" here. With the exception of `Main`, these are stored under `src/State/` in the directory structure. 

Each state machine also has a `view` function, but that function is only responsible for calling relevant views from `src/View`. Because of this, none of the State Machine modules should be using anything from the `Element` module other than the `Element` type itself, which is only used for type annotations.

### Views 

Anything that is rendered to the user (again with the exception of `Main`) is stored in a module in `src/View`. Note, one module may have multiple different exposed functions here, depending on the needs of the rest of the application. There should be a corresponding `View` function for any given `State Machine`, but the inverse is not necessarily true; `View` modules can exist without a corresponding `State Machine`. 

### Types

All top-level modules (once again, with the exception of `Main`) expose a type that matches the name of their module, as well as any functionality that is necessary for that type to be used throughout the rest of the application. With the exception of `Route`, all of these modules intentionally expose opaque types, as I'd rather not allow myself to construct these outside of their modules.

I decided that `Route` was a special case and that it might as well expose its variants to make it less of a headache to link between different routes, although I'm not actually convinced about this, so it may change at some point (and if it does, hopefully I'll remember to update this README too).

## JSON structure

In order to create a game, should you wish to, the structure of the JSON is as follows: 

```
{ "UNIQUE_GAME_KEY" : {
    "name" : String,
    "startingRoom" : String (This must be the same as one of your unique room keys),
    "rooms" : {
        -- As many of these as you like
        "UNIQUE_ROOM_KEY" : {
            "name" : String,
            "intro": String,
            "surroundings": String,
            "surroundingsWhenItemPickedUp" String (optional),
            "surroundingsWhenItemUsed" : String (optional)
            "item" : String (optional - if present, must match one of your unique item keys),
            "availableDirections": [
                { "text" : String,
                  "room" : String (must match one of your unique room keys),
                  "itemsThatCanBeUsed" : [ String ] (can be empty, but must be present)
                }
              ],
            "descriptionWhenExamined" : String,
            "unlockRequirements" : [ String ] (optional, if present strings must match one of your unique item keys)
        }
    }
    "items" : {
        -- As many of these as you like
        "UNIQUE_ITEM_KEY": {
            "name" : String,
            "description" : String,
            "messageWhenUsed" : String,
            "messageWhenNotUsed" : String
        }
    }
  }
}
```
