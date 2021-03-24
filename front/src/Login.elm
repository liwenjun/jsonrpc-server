module Login exposing (Model, Msg, init, update, view)

import Color exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Json.Decode as D
import Json.Encode as E
import JsonRpc exposing (Data(..), RpcData, call, flat, toResult)



-- INIT


type alias Model =
    { username : String
    , password : String
    , token : Maybe String
    , err : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" "" Nothing Nothing
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateUser Model
    | Login
    | GotToken (RpcData String)


update : String -> Msg -> Model -> ( Model, Cmd Msg )
update url msg model =
    case msg of
        UpdateUser u ->
            ( u, Cmd.none )

        Login ->
            ( model
            , signin
                { user = model
                , url = url
                , toMsg = GotToken
                }
            )

        GotToken data ->
            case data |> flat |> toResult of
                Err e ->
                    ( { model | err = e |> Just, token = Nothing }, Cmd.none )

                Ok d ->
                    ( { model | err = Nothing, token = d |> Just }
                    , Cmd.none
                    )



-- VIEW


view : (Msg -> msg) -> Model -> Element msg
view msgMapper model =
    [ el
        [ Region.heading 1
        , centerX
        , Font.size 36
        ]
        (text "测试登录")
    , case model.err of
        Nothing ->
            el
                [ Region.heading 1
                , centerX
                , Font.size 16
                ]
                (text (model.token |> Maybe.withDefault ""))

        Just e ->
            el
                [ Region.heading 1
                , centerX
                , Font.size 16
                , Font.color red_500
                ]
                (text e)
    , Input.username
        [ spacing 12 ]
        { text = model.username
        , placeholder = Nothing
        , onChange = \new -> UpdateUser { model | username = new } |> msgMapper
        , label = Input.labelAbove [ Font.size 14 ] (text "帐号")
        }
    , Input.currentPassword [ spacing 12 ]
        { text = model.password
        , placeholder = Nothing
        , onChange = \new -> UpdateUser { model | password = new } |> msgMapper
        , label = Input.labelAbove [ Font.size 14 ] (text "密码")
        , show = False
        }
    , Input.button
        [ Background.color blue_800
        , Font.color white
        , Border.color blue_900
        , alignRight
        , paddingXY 32 16
        , Border.rounded 3
        ]
        { onPress = Login |> msgMapper |> Just
        , label = Element.text "登录"
        }
    ]
        |> column
            [ width (px 400)
            , height shrink
            , centerY
            , centerX
            , spacing 36
            , padding 10
            , Background.color gray_300
            , Border.color blue_900
            , Border.rounded 3
            ]



-- Func


{-| 用户登录
-}
signin :
    { user : { user | username : String, password : String }
    , url : String
    , toMsg : RpcData String -> msg
    }
    -> Cmd msg
signin options =
    call
        { url = options.url
        , token = Nothing
        , method = "user.signin"
        , params =
            [ ( "password", E.string options.user.password )
            , ( "username", E.string options.user.username )
            ]
        }
        D.string
        options.toMsg
