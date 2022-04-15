module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element exposing (Element, layout)
import Route
import State.ChooseGame as ChooseGame
import State.Game as Game
import State.Home as Home
import Url exposing (Url)
import View.Error as Error



-- MODEL


type alias Model =
    { navKey : Navigation.Key
    , state : State
    }


type State
    = ViewingHomePage Home.State
    | ChoosingGame ChooseGame.State
    | PlayingGame Game.State
    | Error String



-- UPDATE


type Msg
    = UrlChanged Url
    | UrlRequested Browser.UrlRequest
    | ChooseGameMsg ChooseGame.Msg


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

                Route.ChooseGame ->
                    let
                        ( initialState, cmd ) =
                            ChooseGame.init ChooseGameMsg
                    in
                    ( { model | state = ChoosingGame initialState }
                    , cmd
                    )

                Route.Game ->
                    ( { model | state = PlayingGame Game.init }
                    , Cmd.none
                    )

                Route.NotFound ->
                    ( { model
                        | state = Error "Page not found"
                      }
                    , Cmd.none
                    )

        ChooseGameMsg choosingGameMsg ->
            case model.state of
                ChoosingGame choosingGameState ->
                    ( { model | state = ChoosingGame <| ChooseGame.update choosingGameMsg choosingGameState }
                    , Cmd.none
                    )

                _ ->
                    ( { model | state = Error "Something has gone wrong" }
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

                ChoosingGame chooseGameState ->
                    ChooseGame.view chooseGameState

                PlayingGame gameState ->
                    Game.view gameState

                Error str ->
                    Error.view str
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
