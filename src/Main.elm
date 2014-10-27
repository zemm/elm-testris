module Main where

import String
import Text
import Color
import Array
import Debug

import Board (Block, Coord, Grid, Row)
import Tetromino
--import Input


{-
-- Test grid
e = Empty
f = Full orange

grid = Grid.fromLists <| reverse
  [ [f,f,f,e]
  , [f,e,e,f]
  , [f,f,f,f]
  , [e,e,e,f]
  ]
--
g2 = snd <| removeFullRows grid
getBlock' = getBlock grid
isEmpty' = isEmpty grid
fits' = fits grid
--
main = flow down
  [ renderGrid grid
  , plainText " "
  , asText [ getBlock' (0,0), getBlock' (3,0), getBlock' (6,0) ]
  , asText [ isEmpty' (0,0),  isEmpty' (3,0),  isEmpty' (6,0) ]
  , asText [ fits' [(0,0),(1,0),(2,0)] , fits' [(0,0),(1,1)] ]
  , plainText " "
  , renderGrid g2
  , plainText " "
  , renderGridM <| fillEmpty (Full Color.green) (1,2)
    <| gridFromLists (repeat 3 [e,e,e])
  , plainText " "
  , renderGridM <| fillEmpties (Full Color.green) [(0,0),(1,0),(1,1),(2,1)]
    <| gridFromLists (repeat 4 [e,e,e,e,e])
  ]

-}


renderGridM : Maybe Grid -> Element
renderGridM grid = case grid of
  Just g    -> renderGrid g
  otherwise -> leftAligned << monospace <| toText "No grid"

renderGrid : Grid -> Element
renderGrid grid = leftAligned << monospace << toText <| strGrid grid

strGrid : Grid -> String
strGrid grid =
  String.join "\n" <| map strRow (reverse (Array.toList grid))

strRow : Row -> String
strRow row =
  String.join ""
  <| map (\x -> if x == Empty then "-" else "X")
  <| Array.toList row


{-
blockSize = 40

grad : Color -> Gradient
grad color = radial (-10,10) (blockSize / 2.5) (0,0) 90
  [ (0, color)
  , (1, Color.black)
  ]

blockAsForm : Color -> Form
blockAsForm color = gradient (grad color) (rect blockSize blockSize)

blockAsEl : Block -> Element
blockAsEl block =
  let form = case block of
        Empty    -> blockAsForm Color.lightGray
        Filled c -> blockAsForm c
  in collage blockSize blockSize [form]

rowAsEl : Row -> Element
rowAsEl row =
  flow right <| Array.toList <| Array.map blockAsEl row

gridAsEl : Grid -> Element
gridAsEl grid = flow down
  <| Array.map rowAsEl grid
--  <| Array.reverse grid

main = flow down
  [ gridAsEl grid
  , plainText "--"
  --, gridAsEl <| fst grid2
  ]

--}
