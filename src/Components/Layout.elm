module Components.Layout exposing (header)

import Element exposing (..)
import Element.Border as Border


header : String -> Element msg
header title =
    el
        [ Border.widthEach
            { top = 0
            , left = 0
            , right = 0
            , bottom = 1
            }
        , width fill
        ]
    <|
        text title
