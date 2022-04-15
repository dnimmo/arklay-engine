module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element exposing (Element, layout)
import Route
import State.Game as Game
import State.Home as Home
import Url exposing (Url)
import View.NotFound as NotFound



-- MODEL


type alias Model =
    { navKey : Navigation.Key
    , state : State
    }


type State
    = ViewingHomePage Home.State
    | PlayingGame Game.State
    | PageNotFound



-- UPDATE


type Msg
    = UrlChanged Url
    | UrlRequested Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested (Browser.Internal url) ->
            ( model
            , Navigation.pushUrl model.navKey <| Url.toString url
            )

        UrlRequested (Browser.External urlString) ->
            ( model
            , Navigation.load urlString
            )

        UrlChanged url ->
            case Route.fromUrl url of
                Route.Home ->
                    ( { model | state = ViewingHomePage Home.init }
                    , Cmd.none
                    )

                Route.Game ->
                    ( { model | state = PlayingGame Game.init }
                    , Cmd.none
                    )

                Route.NotFound ->
                    ( { model
                        | state = PageNotFound
                      }
                    , Cmd.none
                    )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Arklay"
    , body =
        [ layout [] <|
            case model.state of
                ViewingHomePage homeState ->
                    Home.view homeState

                PlayingGame gameState ->
                    Game.view gameState

                PageNotFound ->
                    NotFound.view
        ]
    }



-- INIT


type alias Flags =
    { height : Int
    , width : Int
    }


init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    ( { navKey = navKey
      , state = ViewingHomePage Home.init
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }
