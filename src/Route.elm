module Route exposing (Route(..), fromUrl, toPath)

import Browser.Navigation as Navigation
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, map, oneOf, parse, s, top)


type Route
    = Home
    | ChooseGame
    | Game
    | NotFound


homeString : String
homeString =
    "home"


chooseGameString : String
chooseGameString =
    "choose-game"


gameString : String
gameString =
    "game"


notFoundString : String
notFoundString =
    "page-not-found"


toString : Route -> String
toString route =
    case route of
        Home ->
            homeString

        ChooseGame ->
            chooseGameString

        Game ->
            gameString

        NotFound ->
            notFoundString


parser : Parser (Route -> Route) Route
parser =
    oneOf
        [ map Home top
        , map Home <| s homeString
        , map ChooseGame <| s chooseGameString
        , map Game <| s gameString
        ]


fromUrl : Url -> Route
fromUrl url =
    Maybe.withDefault NotFound <|
        parse parser url


toPath : Route -> String
toPath route =
    "/" ++ toString route
