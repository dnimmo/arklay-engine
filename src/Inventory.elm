module Inventory exposing
    ( Inventory
    , addItem
    , containsItem
    , emptyInventory
    , getItem
    , getItemsWithIds
    , itemHasBeenUsed
    , useItem
    )

import Dict exposing (Dict)
import Item exposing (Item)
import Set exposing (Set)


type Inventory
    = Inventory
        { items : Dict String Item
        , itemsUsed : Set String
        }


addItem : Inventory -> String -> Item -> Inventory
addItem (Inventory ({ items } as inventoryDetails)) itemId item =
    Inventory <|
        { inventoryDetails
            | items = Dict.insert itemId item items
        }


useItem : Inventory -> String -> Inventory
useItem (Inventory ({ itemsUsed } as inventoryDetails)) itemId =
    Inventory <|
        { inventoryDetails
            | itemsUsed = Set.insert itemId itemsUsed
        }


containsItem : Inventory -> String -> Bool
containsItem (Inventory { items }) itemId =
    Dict.member itemId items


emptyInventory : Inventory
emptyInventory =
    Inventory
        { items = Dict.empty
        , itemsUsed = Set.empty
        }


getItem : Inventory -> String -> Maybe Item
getItem (Inventory { items }) itemId =
    Dict.get itemId items


getItemsWithIds : Inventory -> List ( String, Item )
getItemsWithIds (Inventory { items }) =
    Dict.toList items


itemHasBeenUsed : Inventory -> String -> Bool
itemHasBeenUsed (Inventory { itemsUsed }) itemId =
    Set.member itemId itemsUsed
