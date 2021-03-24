module Register exposing (Model, Msg, init, update, view)

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
    , result : Int
    , err : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" "" -1 Nothing
    , Cmd.none
    )



-- UPDATE


type Msg
    = UpdateUser Model
    | Login
    | GotResult (RpcData Int)


update : String -> Maybe String -> Msg -> Model -> ( Model, Cmd Msg )
update url token msg model =
    case msg of
        UpdateUser u ->
            ( u, Cmd.none )

        Login ->
            ( model
            , signup
                { user = model
                , url = url
                , token = token
                , toMsg = GotResult
                }
            )

        GotResult data ->
            case data |> flat |> toResult of
                Err e ->
                    ( { model | err = e |> Just, result = -1 }, Cmd.none )

                Ok d ->
                    ( { model | err = Nothing, result = d }
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
        (text "测试注册新用户")
    , case model.err of
        Nothing ->
            el
                [ Region.heading 1
                , centerX
                , Font.size 16
                ]
                ((case model.result of
                    1 ->
                        "注册成功"

                    0 ->
                        "用户已存在"

                    _ ->
                        ""
                 )
                    |> text
                )

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
        [ Background.color orange_500
        , Font.color white
        , Border.color blue_900
        , alignRight
        , paddingXY 32 16
        , Border.rounded 3
        ]
        { onPress = Login |> msgMapper |> Just
        , label = Element.text "注册"
        }
    ]
        |> column
            [ width (px 400)
            , height shrink
            , centerY
            , centerX
            , spacing 36
            , padding 10
            , Background.color teal_300
            , Border.color blue_900
            , Border.rounded 3
            ]



-- Func


{-| 注册新用户
-}
signup :
    { user : { user | username : String, password : String }
    , url : String
    , token : Maybe String
    , toMsg : RpcData Int -> msg
    }
    -> Cmd msg
signup options =
    call
        { url = options.url
        , token = options.token
        , method = "user.signup"
        , params =
            [ ( "password", E.string options.user.password )
            , ( "username", E.string options.user.username )
            ]
        }
        D.int
        options.toMsg
