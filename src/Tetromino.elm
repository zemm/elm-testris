module Tetromino where

import Color

type Coord = (Int,Int)

-- Try to follow http://tetris.wikia.com/wiki/Tetris_Guideline

-- @TODO: rotate by SRS, needs pivot?

type Piece =
  { tetromino:Tetromino
  , color:Color.Color
  , pos:Coord
  , rot:Int
  , shape:[Coord]
  }

data Tetromino = Custom | I | O | T | S | Z | J | L


--
-- Functionality
--

color : Piece -> Color
color = .color

-- @TODO: apply rotation and transformation
project : Piece -> [Coord]

rotateCW : Piece -> Piece

rotateCCW : Piece -> Piece

move : Dir -> Piece -> Piece

--
-- Factory
--

-- @TODO: lazy seedable random bag generator
--createRandomBag : Int -> (Coord -> Piece)

create : Tetromino -> Coord -> Piece
create tetromino pos =
    { tetromino = tetromino
    , color = colorFor tetromino
    , pos = pos
    , rot = 0
    , shape = shapeFor tetromino
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

shapeFor : Tetromino -> [Coord]
shapeFor tetromino =
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
