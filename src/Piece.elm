module Piece where

import Color

-- Try to follow http://tetris.wikia.com/wiki/Tetris_Guideline
-- @TODO: rotate by SRS, needs pivot?

type Coord = (Int,Int)
type Shape = [Coord]
type Rotation = Int

type Piece =
  { tetromino:Tetromino
  , color:Color.Color
  , position:Coord
  , rotation:Rotation
  , shape:Shape
  }

data Tetromino = Custom | I | O | T | S | Z | J | L

--
-- Functionality
--
color : Piece -> Color
color = .color

upperBounds : Shape -> Coord
upperBounds shape =
  let (xs, ys) = unzip shape
  in (maximum xs, maximum ys)

lowerBounds : Shape -> Coord
lowerBounds shape =
  let (xs, ys) = unzip shape
  in (minimum xs, minimum ys)

-- apply rotation and translation
project : Piece -> Shape
project piece =
  translateShape piece.position
  <| rotateShape piece.rotation piece.shape

rotateShape : Rotation -> Shape -> Shape
rotateShape rotation shape =
  let safeRot = rotation % 4
      fun = case safeRot of
        0 -> \(x, y) -> ( x,  y)
        1 -> \(x, y) -> ( y, -x)
        2 -> \(x, y) -> (-x, -y)
        3 -> \(x, y) -> (-y,  x)
  in map fun shape

translateShape : Coord -> Shape -> Shape
translateShape (dX, dY) shape =
  map (\(x, y) -> (x+dX, y+dY)) shape

rotateCW : Piece -> Piece
rotateCW piece = { piece | rotation <- (piece.rotation + 1) % 4 }

rotateCCW : Piece -> Piece
rotateCCW piece = { piece | rotation <- (piece.rotation - 1) % 4 }

move : Coord -> Piece -> Piece
move (dX, dY) piece =
  let (oldX, oldY) = piece.position
  in { piece | position <- (oldX + dX, oldY + dY) }

--
-- Factory
--

-- @TODO: lazy seedable random bag generator
--createRandomBag : Int -> (Coord -> Piece)

create : Tetromino -> Coord -> Piece
create tetromino position =
    { tetromino = tetromino
    , color = colorFor tetromino
    , position = position
    , rotation = 0
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

{-
http://tetrisconcept.net/wiki/File:SRS-true-rotations.png
http://tetrisconcept.net/wiki/images/3/3d/SRS-pieces.png
-}
shapeFor : Tetromino -> Shape
shapeFor tetromino =
    case tetromino of
        I -> [
               (-1,0),(0,0),(1,0),(2,0) ]

        O -> [        (0,1),(1,1)
             ,        (0,0),(1,0)       ]

        T -> [        (0,1)
             , (-1,0),(0,0),(1,0)       ]

        S -> [        (0,1),(1,1)
             , (-1,0),(0,0)             ]

        Z -> [ (-1,1),(0,1)
             ,        (0,0),(1,0)       ]

        J -> [ (-1,1)
             , (-1,0),(0,0),(1,0)       ]

        L -> [              (1,1)
             , (-1,0),(0,0),(1,0)       ]
