module View.Inventory exposing (view)

import Element exposing (..)
import Element.Input as Input
import Inventory exposing (Inventory)
import Item exposing (Item)


itemElement : (String -> msg) -> ( String, Item ) -> Element msg
itemElement useItemMsg ( itemId, item ) =
    Input.button []
        { onPress = Just <| useItemMsg itemId
        , label = text <| Item.getName item
        }


view : { inventory : Inventory, useItemMsg : String -> msg } -> Element msg
view { inventory, useItemMsg } =
    column [] <|
        text "inventory"
            :: List.map (itemElement useItemMsg)
                (Inventory.getItemsWithIds inventory)
