module Piece where

import Color

type Pos2 = (Int,Int)
type Size2 = (Int,Int)
type Shape = [Pos2]
type Rotation = Int

type Piece =
  { tetromino:Tetromino
  , color:Color.Color
  , position:Pos2
  , rotation:Rotation
  , shape:Shape
  }

data Tetromino = Custom | I | O | T | S | Z | J | L

--
-- Functionality
--
color : Piece -> Color
color = .color

upperBounds : Shape -> Pos2
upperBounds shape =
  let (xs, ys) = unzip shape
  in (maximum xs, maximum ys)

lowerBounds : Shape -> Pos2
lowerBounds shape =
  let (xs, ys) = unzip shape
  in (minimum xs, minimum ys)

aabbPieceMax : Piece -> Int
aabbPieceMax piece = aabbShapeMax piece.shape

aabbShapeMax : Shape -> Int
aabbShapeMax shape =
  let (xs, ys) = unzip shape
      minXY = min (minimum xs) (minimum ys)
      maxXY = max (maximum xs) (maximum ys)
  in maxXY + 1 - minXY

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

translateShape : Pos2 -> Shape -> Shape
translateShape (dX, dY) shape =
  map (\(x, y) -> (x+dX, y+dY)) shape

rotateCW : Piece -> Piece
rotateCW piece = { piece | rotation <- (piece.rotation + 1) % 4 }

rotateCCW : Piece -> Piece
rotateCCW piece = { piece | rotation <- (piece.rotation - 1) % 4 }

move : Pos2 -> Piece -> Piece
move (dX, dY) piece =
  let (oldX, oldY) = piece.position
  in { piece | position <- (oldX + dX, oldY + dY) }

--
-- Factory
--

-- @TODO: lazy seedable random bag generator
--createRandomBag : Int -> (Pos2 -> Piece)

create : Tetromino -> Pos2 -> Piece
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
