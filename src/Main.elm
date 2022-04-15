module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element exposing (..)
import Url exposing (Url)



-- MODEL


type Model
    = Model



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
        [ layout [] <| text "Hello"
        ]
    }



-- INIT

type alias Flags = 
    { height : Int 
    , width : Int }

init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    ( Model
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
