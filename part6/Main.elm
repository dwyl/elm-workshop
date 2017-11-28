module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, target, href, property, defaultValue)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (..)
import SampleResponse


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { view = view
        , update = update
        , model = initialModel
        }


searchResultDecoder : Decoder SearchResult
searchResultDecoder =
    decode SearchResult
        |> required "id" int
        |> required "full_name" string
        |> required "stargazers_count" int

  
type alias Model =
    { query : String
    , results : List SearchResult
    }


type alias SearchResult =
    { id : Int
    , name : String
    , stars : Int
    }


initialModel : Model
initialModel =
    { query = "tutorial"
    , results = decodeResults SampleResponse.json
    }


responseDecoder : Decoder (List SearchResult)
responseDecoder =
    decode identity
        |> required "items" (list searchResultDecoder)


decodeResults : String -> List SearchResult
decodeResults json =
    case decodeString responseDecoder json of
        Ok searchResults ->
            searchResults

        Err errorMessage ->
            []

view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ header []
            [ h1 [] [ text "ElmHub" ]
            , span [ class "tagline" ] [ text "Like GitHub, but for Elm things." ]
            ]
        , input [ class "search-query", onInput SetQuery, defaultValue model.query ] []
        , button [ class "search-button" ] [ text "Search" ]
        , ul [ class "results" ]
            (List.map viewSearchResult model.results)
        ]


viewSearchResult : SearchResult -> Html Msg
viewSearchResult result =
    li []
        [ span [ class "star-count" ] [ text (toString result.stars) ]
        , a [ href ("https://github.com/" ++ result.name), target "_blank" ]
            [ text result.name ]
        , button [ class "hide-result", onClick (DeleteById result.id) ]
            [ text "X" ]
        ]


type Msg
    = SetQuery String
    | DeleteById Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetQuery query ->
            { model | query = query }

        DeleteById idToHide ->
            let
                newResults =
                    List.filter (\{ id } -> id /= idToHide) model.results
            in
                { model | results = newResults }
