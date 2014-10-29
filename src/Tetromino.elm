module Tetromino where

import Color

type Pos2 = (Int,Int)

type Shape = [Pos2]

type Rotation = Int

type Tetromino =
  { kind:Kind
  , color:Color.Color
  , position:Pos2
  , rotation:Rotation
  , shape:Shape
  }

data Kind = Custom | I | O | T | S | Z | J | L

--
-- Functionality
--
color : Tetromino -> Color
color = .color

upperBounds : Shape -> Pos2
upperBounds shape =
  let (xs, ys) = unzip shape
  in (maximum xs, maximum ys)

lowerBounds : Shape -> Pos2
lowerBounds shape =
  let (xs, ys) = unzip shape
  in (minimum xs, minimum ys)

aabbMax : Shape -> Int
aabbMax shape =
  let (xs, ys) = unzip shape
      minXY = min 0 (min (minimum xs) (minimum ys))
      maxXY = max (maximum xs) (maximum ys)
  in maxXY + 1 - minXY

-- apply rotation and translation
project : Tetromino -> Shape
project tetromino =
  translateShape tetromino.position
  <| rotateShape tetromino.rotation tetromino.shape

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

rotateCW : Tetromino -> Tetromino
rotateCW tetromino = { tetromino | rotation <- (tetromino.rotation + 1) % 4 }

rotateCCW : Tetromino -> Tetromino
rotateCCW tetromino = { tetromino | rotation <- (tetromino.rotation - 1) % 4 }

move : Pos2 -> Tetromino -> Tetromino
move (dX, dY) tetromino =
  let (oldX, oldY) = tetromino.position
  in { tetromino | position <- (oldX + dX, oldY + dY) }

--
-- Factory
--

-- @TODO: lazy seedable random bag generator
--createRandomBag : Int -> (Pos2 -> Tetromino)

create : Kind -> Pos2 -> Tetromino
create kind position =
    { kind = kind
    , color = colorFor kind
    , position = position
    , rotation = 0
    , shape = shapeFor kind
    }

colorFor : Kind -> Color.Color
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
shapeFor : Kind -> Shape
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
