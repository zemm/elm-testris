module Input where

import Signal
import Keyboard
import Time
import Maybe

import Board
import Tetromino

data Source = User | System
data MoveDir = Left | Right
data RotateDir = CW | CCW

data Action =
    Tick Time
  | Pause
  | SoftDrop
  | HardDrop
  | Move MoveDir
  | Rotate RotateDir

input : Signal (Maybe Action)
input = userInput
--input = Signal.merge userInput systemInput

{- System input (clock)

@TODO: 60fps clock
@TODO: reset clock (pause etc)
@TODO: Tunable soft drop signals (clock)
  - requires tunable / depends on another signal - was this not currently possible?
  - or should the logic for this be elsewhere?

-}

systemInput : Signal Action
systemInput = (\d -> Tick d) <~ clock

clock : Signal Time
clock = fps 60

{- User input (keys)
@TODO: repeat with a delay
@TODO: rotateCCW
-}

userInput : Signal (Maybe Action)
userInput = Signal.keepIf Maybe.isJust Nothing <| Signal.merges
  [ mapArrows <~ Keyboard.arrows
  , mapTrueTo HardDrop <~ Keyboard.space
  , mapTrueTo Pause <~ Keyboard.enter
  ]

mapTrueTo : Action -> Bool -> Maybe Action
mapTrueTo action space = if space then Just action else Nothing

mapArrows : {x:Int, y:Int} -> Maybe Action
mapArrows {x,y} =
  if | x > 0     -> Just (Move Right)
     | x < 0     -> Just (Move Left)
     | y < 0     -> Just SoftDrop
     | y > 0     -> Just (Rotate CW)
     | otherwise -> Nothing
