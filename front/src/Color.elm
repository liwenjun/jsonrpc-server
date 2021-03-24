module Color exposing (..)

import Element exposing (Color, rgb255)


{-| 配色方案借鉴了Tailwindcss
-}
green_sg : Color
green_sg =
    rgb255 0 101 105


black : Color
black =
    rgb255 0 0 0


white : Color
white =
    rgb255 255 255 255



-- Grey
-- 扩展色， 不含在 tailwindcss 中


grey_100 : Color
grey_100 =
    rgb255 252 252 252


grey_200 : Color
grey_200 =
    rgb255 247 247 247


grey_300 : Color
grey_300 =
    rgb255 240 240 240


grey_400 : Color
grey_400 =
    rgb255 224 224 224


grey_500 : Color
grey_500 =
    rgb255 192 192 192


grey_600 : Color
grey_600 =
    rgb255 150 150 150


grey_700 : Color
grey_700 =
    rgb255 104 104 104


grey_800 : Color
grey_800 =
    rgb255 72 72 72


grey_900 : Color
grey_900 =
    rgb255 44 44 44



-- Gray


gray_100 : Color
gray_100 =
    rgb255 247 252 252


gray_200 : Color
gray_200 =
    rgb255 237 247 247


gray_300 : Color
gray_300 =
    rgb255 226 240 240


gray_400 : Color
gray_400 =
    rgb255 203 224 224


gray_500 : Color
gray_500 =
    rgb255 160 192 192


gray_600 : Color
gray_600 =
    rgb255 113 150 150


gray_700 : Color
gray_700 =
    rgb255 74 104 104


gray_800 : Color
gray_800 =
    rgb255 45 72 72


gray_900 : Color
gray_900 =
    rgb255 26 44 44



-- Red


red_100 : Color
red_100 =
    rgb255 255 245 245


red_200 : Color
red_200 =
    rgb255 254 215 215


red_300 : Color
red_300 =
    rgb255 254 178 178


red_400 : Color
red_400 =
    rgb255 252 129 129


red_500 : Color
red_500 =
    rgb255 245 101 101


red_600 : Color
red_600 =
    rgb255 229 62 62


red_700 : Color
red_700 =
    rgb255 197 48 48


red_800 : Color
red_800 =
    rgb255 155 44 44


red_900 : Color
red_900 =
    rgb255 116 42 42



-- Orange


orange_100 : Color
orange_100 =
    rgb255 255 240 240


orange_200 : Color
orange_200 =
    rgb255 254 200 200


orange_300 : Color
orange_300 =
    rgb255 251 141 141


orange_400 : Color
orange_400 =
    rgb255 246 85 85


orange_500 : Color
orange_500 =
    rgb255 237 54 54


orange_600 : Color
orange_600 =
    rgb255 221 32 32


orange_700 : Color
orange_700 =
    rgb255 192 33 33


orange_800 : Color
orange_800 =
    rgb255 156 33 33


orange_900 : Color
orange_900 =
    rgb255 123 30 30



-- Yellow


yellow_100 : Color
yellow_100 =
    rgb255 255 240 240


yellow_200 : Color
yellow_200 =
    rgb255 254 191 191


yellow_300 : Color
yellow_300 =
    rgb255 250 137 137


yellow_400 : Color
yellow_400 =
    rgb255 246 94 94


yellow_500 : Color
yellow_500 =
    rgb255 236 75 75


yellow_600 : Color
yellow_600 =
    rgb255 214 46 46


yellow_700 : Color
yellow_700 =
    rgb255 183 31 31


yellow_800 : Color
yellow_800 =
    rgb255 151 22 22


yellow_900 : Color
yellow_900 =
    rgb255 116 16 16



-- Green


green_100 : Color
green_100 =
    rgb255 240 244 244


green_200 : Color
green_200 =
    rgb255 198 213 213


green_300 : Color
green_300 =
    rgb255 154 180 180


green_400 : Color
green_400 =
    rgb255 104 145 145


green_500 : Color
green_500 =
    rgb255 72 120 120


green_600 : Color
green_600 =
    rgb255 56 105 105


green_700 : Color
green_700 =
    rgb255 47 90 90


green_800 : Color
green_800 =
    rgb255 39 73 73


green_900 : Color
green_900 =
    rgb255 34 61 61



-- Teal


teal_100 : Color
teal_100 =
    rgb255 230 250 250


teal_200 : Color
teal_200 =
    rgb255 178 234 234


teal_300 : Color
teal_300 =
    rgb255 129 217 217


teal_400 : Color
teal_400 =
    rgb255 79 197 197


teal_500 : Color
teal_500 =
    rgb255 56 172 172


teal_600 : Color
teal_600 =
    rgb255 49 149 149


teal_700 : Color
teal_700 =
    rgb255 44 123 123


teal_800 : Color
teal_800 =
    rgb255 40 97 97


teal_900 : Color
teal_900 =
    rgb255 35 82 82



-- Blue


blue_100 : Color
blue_100 =
    rgb255 235 255 255


blue_200 : Color
blue_200 =
    rgb255 190 248 248


blue_300 : Color
blue_300 =
    rgb255 144 244 244


blue_400 : Color
blue_400 =
    rgb255 99 237 237


blue_500 : Color
blue_500 =
    rgb255 66 225 225


blue_600 : Color
blue_600 =
    rgb255 49 206 206


blue_700 : Color
blue_700 =
    rgb255 43 176 176


blue_800 : Color
blue_800 =
    rgb255 44 130 130


blue_900 : Color
blue_900 =
    rgb255 42 101 101



-- Indigo 靛蓝


indigo_100 : Color
indigo_100 =
    rgb255 235 255 255


indigo_200 : Color
indigo_200 =
    rgb255 195 254 254


indigo_300 : Color
indigo_300 =
    rgb255 163 250 250


indigo_400 : Color
indigo_400 =
    rgb255 127 245 245


indigo_500 : Color
indigo_500 =
    rgb255 102 234 234


indigo_600 : Color
indigo_600 =
    rgb255 90 216 216


indigo_700 : Color
indigo_700 =
    rgb255 76 191 191


indigo_800 : Color
indigo_800 =
    rgb255 67 144 144


indigo_900 : Color
indigo_900 =
    rgb255 60 107 107



-- Purple 紫色


purple_100 : Color
purple_100 =
    rgb255 250 255 255


purple_200 : Color
purple_200 =
    rgb255 233 253 253


purple_300 : Color
purple_300 =
    rgb255 214 250 250


purple_400 : Color
purple_400 =
    rgb255 183 244 244


purple_500 : Color
purple_500 =
    rgb255 159 234 234


purple_600 : Color
purple_600 =
    rgb255 128 213 213


purple_700 : Color
purple_700 =
    rgb255 107 193 193


purple_800 : Color
purple_800 =
    rgb255 85 154 154


purple_900 : Color
purple_900 =
    rgb255 68 122 122



-- Pink


pink_100 : Color
pink_100 =
    rgb255 255 247 247


pink_200 : Color
pink_200 =
    rgb255 254 226 226


pink_300 : Color
pink_300 =
    rgb255 251 206 206


pink_400 : Color
pink_400 =
    rgb255 246 179 179


pink_500 : Color
pink_500 =
    rgb255 237 166 166


pink_600 : Color
pink_600 =
    rgb255 213 140 140


pink_700 : Color
pink_700 =
    rgb255 184 128 128


pink_800 : Color
pink_800 =
    rgb255 151 109 109


pink_900 : Color
pink_900 =
    rgb255 112 89 89
