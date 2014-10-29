module Tetromino where

import Color
import Array

type Pos2 = (Int,Int)

type Shape = [Pos2]

type Rotation = Int

type Tetromino =
  { kind:Kind
  , color:Color.Color
  , position:Pos2
  , rotation:Rotation
  }

data Kind = I | O | T | S | Z | J | L

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

shapeAabbMax : Shape -> Int
shapeAabbMax shape =
  let (xs, ys) = unzip shape
      minXY = min 0 (min (minimum xs) (minimum ys))
      maxXY = max (maximum xs) (maximum ys)
  in maxXY + 1 - minXY

-- apply rotation and translation
project : Tetromino -> Shape
project tetromino =
  rotatedTetrominoShape tetromino |> translateTetrominoShape tetromino

rotatedTetrominoShape : Tetromino -> Shape
rotatedTetrominoShape tetromino =
  baseShape tetromino.kind |> rotateShape tetromino.rotation

rotateShape : Rotation -> Shape -> Shape
rotateShape rotation shape =
  let safeRot = rotation % 4
      fun = case safeRot of
        0 -> \(x, y) -> ( x,  y)
        1 -> \(x, y) -> ( y, -x)
        2 -> \(x, y) -> (-x, -y)
        3 -> \(x, y) -> (-y,  x)
  in map fun shape

-- include rotational offsets
translateTetrominoShape : Tetromino -> Shape -> Shape
translateTetrominoShape tetromino shape =
  let (tx, ty) = tetromino.position
      offset = rotationalOffset tetromino.kind tetromino.rotation
  in case offset of
    Just (dx, dy) -> translateShape (tx+dx, ty+dy) shape
    Nothing       -> translateShape (tx, ty) shape

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

-- With current data structure, I and O blocks have to be fixed after rotation
-- @see http://tetrisconcept.net/wiki/File:SRS-true-rotations.png
--      http://tetrisconcept.net/wiki/images/3/3d/SRS-pieces.png
rotationalOffset : Kind -> Rotation -> Maybe Pos2
rotationalOffset kind rotation =
  case kind of
    O -> case rotation of
           0 -> Nothing
           1 -> Just (0,1)
           2 -> Just (1,1)
           3 -> Nothing
    I -> case rotation of
           0 -> Just (0,1)
           1 -> Just (1,1)
           2 -> Just (1,0)
           3 -> Nothing
    _ -> Nothing

baseShape : Kind -> Shape
baseShape kind =
  case kind of
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
