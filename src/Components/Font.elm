module Components.Font exposing (..)

import Element exposing (..)
import Element.Font as Font


bodyFont : Attribute msg
bodyFont =
    Font.family
        [ Font.typeface "Source Code Pro"
        ]


mainColour : Attribute msg
mainColour =
    Font.color <| rgb255 250 250 250
