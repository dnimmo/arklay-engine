module Components.Background exposing (..)

import Element exposing (..)
import Element.Background as Background


mainColour : Attribute msg
mainColour =
    Background.color <| rgb255 10 10 10
