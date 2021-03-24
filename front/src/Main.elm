module Main exposing (main)

{-| -}

import Browser
import Color exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input exposing (button)
import Html exposing (Html)
import JsonRpc
import Login
import Register



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



-- MODEL


type ShowModel
    = None
    | TestLogin
    | TestRegister


type alias Model =
    { url : String
    , token : Maybe String
    , show : ShowModel
    , login : Login.Model
    , register : Register.Model
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        model =
            Model "http://127.0.0.1:3000/jsonrpc/v2"
                Nothing
                TestLogin
                (Login.init |> Tuple.first)
                (Register.init |> Tuple.first)
    in
    ( model, Cmd.none )



-- UPDATE


type Msg
    = MenuClick Model
    | LoginMsg Login.Msg
    | RegisterMsg Register.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MenuClick data ->
            ( data, Cmd.none )

        LoginMsg message ->
            let
                ( m, c ) =
                    Login.update model.url message model.login
            in
            ( { model | login = m, token = m.token }
            , Cmd.map LoginMsg c
            )

        RegisterMsg message ->
            let
                ( m, c ) =
                    Register.update model.url model.token message model.register
            in
            ( { model | register = m }
            , Cmd.map RegisterMsg c
            )



-- VIEW


view : Model -> Html Msg
view model =
    (case model.show of
        None ->
            text "TODO"

        TestLogin ->
            Login.view (\msg -> LoginMsg msg) model.login

        TestRegister ->
            Register.view (\msg -> RegisterMsg msg) model.register
    )
        |> el [ centerX, centerY, padding 50 ]
        |> layout
            [ width fill, height fill, inFront (menu model) ]


menu : Model -> Element Msg
menu model =
    row
        [ width fill
        , padding 20
        , spacing 20
        , Border.widthEach { right = 0, left = 0, top = 0, bottom = 2 }
        , Border.color blue_500
        ]
        [ button [] { onPress = MenuClick { model | show = TestLogin } |> Just, label = text "测试登录功能" }
        , button [] { onPress = MenuClick { model | show = TestRegister } |> Just, label = text "测试注册功能" }
        , button [] { onPress = MenuClick { model | show = None } |> Just, label = text "测试xx功能" }
        ]
