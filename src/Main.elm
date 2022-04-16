module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element exposing (Element, layout)
import Game exposing (Game)
import Route
import State.ChooseGame as ChooseGame
import State.Game as Game
import Url exposing (Url)
import View.Error as Error
import View.Home as Home



-- MODEL


type alias Model =
    { navKey : Navigation.Key
    , state : State
    }


type State
    = ViewingHomePage
    | ChoosingGame ChooseGame.State
    | PlayingGame Game.State
    | Error String



-- UPDATE


type Msg
    = UrlChanged Url
    | UrlRequested Browser.UrlRequest
    | ChooseGameMsg ChooseGame.Msg
    | GameMsg Game.Msg


handleUrlChange : Model -> Url -> ( Model, Cmd Msg )
handleUrlChange model url =
    case Route.fromUrl url of
        Route.Home ->
            ( { model | state = ViewingHomePage }
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

        Route.Game gameId ->
            let
                ( initialState, cmd ) =
                    Game.init GameMsg gameId
            in
            ( { model | state = PlayingGame initialState }
            , cmd
            )

        Route.NotFound ->
            ( { model
                | state = Error "Page not found"
              }
            , Cmd.none
            )


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
            handleUrlChange model url

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

        GameMsg gameMsg ->
            case model.state of
                PlayingGame gameState ->
                    let
                        ( newState, cmd ) =
                            Game.update GameMsg gameMsg gameState
                    in
                    ( { model | state = PlayingGame newState }
                    , cmd
                    )

                _ ->
                    ( { model
                        | state = Error "Something has gone wrong"
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
                ViewingHomePage ->
                    Home.view

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
    handleUrlChange
        { navKey = navKey
        , state = ViewingHomePage
        }
        url


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
