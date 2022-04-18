module Inventory exposing
    ( Inventory
    , addItem
    , containsItem
    , emptyInventory
    , getItemsWithIds
    )

import Dict exposing (Dict)
import Item exposing (Item)


type Inventory
    = Inventory { items : Dict String Item }


addItem : Inventory -> String -> Item -> Inventory
addItem (Inventory { items }) itemId item =
    Inventory <|
        { items = Dict.insert itemId item items
        }


containsItem : Inventory -> String -> Bool
containsItem (Inventory { items }) itemId =
    Dict.member itemId items


emptyInventory : Inventory
emptyInventory =
    Inventory
        { items = Dict.empty }


getItemsWithIds : Inventory -> List ( String, Item )
getItemsWithIds (Inventory { items }) =
    Dict.toList items
