module Input where

import Signal
import Keyboard
import Time

import Board
import Tetromino

data Source = User | Clock

data MoveDir = Left | Right

data RotDir = CW | CCW

data Action =
    SoftDrop Source
  | HardDrop
  | Move MoveDir
  | Rotate RotDir

{-

@TODO:

lazy seedable random bag Tetromino generator

createRandomBag : [(Pos2 -> Tetromino)] -> Pos2 -> Tetromino -- kinds could be factories
createRandomBag seed kinds startPos =

createSeededRandomBag : Int -> [Kind] -> Pos2 -> Tetromino
createSeededRandomBag seed kinds startPos =

60fps clock

left / right movement (keyboard)
    - repeat with a delay on keydown

cw / ccw rotation (keyboard)

tunable soft drop signals (clock)
  - requires tunable / depends on another signal - was this not currently possible?
  - or should the logic for this be elsewhere?

soft drop signals (keyboard)

hard drop signals (keyboard)

combine and tag signals to action singals

-}
