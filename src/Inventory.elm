module Inventory exposing (Inventory, emptyInventory)

import Dict exposing (Dict)
import Item exposing (Item)


type Inventory
    = Inventory (Maybe (Dict String Item))


emptyInventory : Inventory
emptyInventory =
    Inventory Nothing
