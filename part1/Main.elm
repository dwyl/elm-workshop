module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


main =
    div [ class "content" ]
        [ header []
            [ h1 [] [ text "ElmHub" ]
            , span [ class "tagline" ] [ text "Like GitHub, but for Elm things." ]
            ]
        ]
