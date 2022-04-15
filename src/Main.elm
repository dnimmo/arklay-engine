module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element exposing (Element, layout)
import State.Home as Home
import Url exposing (Url)



-- MODEL


type alias Model =
    { navKey : Navigation.Key
    , state : State
    }


type State
    = ViewingHomePage Home.State



-- UPDATE


type Msg
    = UrlChanged Url
    | UrlRequested Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model
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
