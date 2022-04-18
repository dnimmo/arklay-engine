module View.Inventory exposing (view)

import Components.Layout as Layout
import Element exposing (..)
import Element.Input as Input
import Inventory exposing (Inventory)
import Item exposing (Item)


itemElement : Inventory -> (String -> msg) -> ( String, Item ) -> Element msg
itemElement inventory useItemMsg ( itemId, item ) =
    let
        hasBeenUsed =
            Inventory.itemHasBeenUsed inventory itemId
    in
    if hasBeenUsed then
        el [ alpha 0.7 ] <|
            text <|
                Item.getName item

    else
        Input.button
            []
            { onPress =
                Just <| useItemMsg itemId
            , label = text <| Item.getName item
            }


view : { inventory : Inventory, useItemMsg : String -> msg } -> Element msg
view { inventory, useItemMsg } =
    column
        [ width fill
        , height fill
        , spacing 20
        ]
    <|
        Layout.header "Inventory"
            :: List.map (itemElement inventory useItemMsg)
                (Inventory.getItemsWithIds inventory)
