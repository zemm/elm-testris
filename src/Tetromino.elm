module Tetromino where

import Color

type Coord = (Int,Int)

-- Try to follow http://tetris.wikia.com/wiki/Tetris_Guideline

-- @TODO: rotate by SRS, needs pivot?

type Shape =
  { tetromino:Tetromino
  , color:Color.Color
  , pos:Coord
  , rot:Int
  , coords:[Coord]
  }

data Tetromino = Custom | I | O | T | S | Z | J | L

--createRandom : Coord -> Shape

create : Tetromino -> Coord -> Shape
create tetromino pos =
    { tetromino = tetromino
    , color = colorFor tetromino
    , pos = pos
    , rot = 0
    , coords = coordsFor tetromino
    }

colorFor : Tetromino -> Color.Color
colorFor tetromino =
    case tetromino of
        I -> Color.rgb 0 255 255 --cyan
        O -> Color.yellow
        T -> Color.purple
        S -> Color.green
        Z -> Color.red
        J -> Color.blue
        L -> Color.orange

coordsFor : Tetromino -> [Coord]
coordsFor tetromino =
    case tetromino of
        I -> [ (0,1),(1,1),(2,1),(3,1) ]

        O -> [       (1,0),(2,0)
             ,       (1,1),(2,1)       ]

        T -> [       (1,0)
             , (0,1),(1,1),(2,1)       ]

        S -> [       (1,0),(2,1)
             , (0,1),(1,1)             ]

        Z -> [ (0,0),(1,0)
             ,       (1,1),(2,1)       ]

        J -> [ (0,0)
             , (0,1),(1,1),(2,1)       ]

        L -> [             (2,0)
             , (0,1),(1,1),(2,1)       ]

projectShape : Shape -> [Coord]
projectShape shape = shape.coords

-- TODO

main = asText <| create T (0,0)

