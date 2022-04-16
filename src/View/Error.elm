module View.Error exposing
    ( httpErrorView
    , view
    )

import Element exposing (..)
import Http
import Route


view : String -> Element msg
view str =
    column []
        [ text str
        , link []
            { url = Route.toPath Route.Home
            , label = text "Go back"
            }
        ]


httpErrorView : Http.Error -> Element msg
httpErrorView err =
    view <|
        "Please accept our apologies, something has gone wrong. "
            ++ (case err of
                    Http.BadUrl str ->
                        "There was a problem with the URL requested: " ++ str

                    Http.Timeout ->
                        "The request timed out. Please check your connection and try again."

                    Http.NetworkError ->
                        "There seems to be a problem with your connection. Please check your connection and try again."

                    Http.BadStatus int ->
                        "Received status: " ++ String.fromInt int

                    Http.BadBody str ->
                        str
               )
