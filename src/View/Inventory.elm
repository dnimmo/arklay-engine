module View.Inventory exposing (view)

import Element exposing (..)
import Inventory exposing (Inventory)
import Item exposing (Item)


itemElement : ( String, Item ) -> Element msg
itemElement ( itemId, item ) =
    text <| Item.getName item


view : Inventory -> Element msg
view inventory =
    column [] <|
        text "inventory"
            :: List.map itemElement
                (Inventory.getItemsWithIds inventory)
