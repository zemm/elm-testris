module Main where

import String
import Text
import Color
import Array
import List
import Debug

import Grid (Block(..), Coord, Row, Grid)
import Grid
import Piece (Piece)
import Piece
--import Input


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
getBlock' = Grid.getBlock grid
isEmpty' = Grid.isEmpty grid
fits' = Grid.fits grid
pcs = [ Piece.create Piece.I (3,3)
      , Piece.create Piece.O (3,3)
      , Piece.create Piece.T (3,3)
      , Piece.create Piece.S (3,3)
      , Piece.create Piece.Z (3,3)
      , Piece.create Piece.J (3,3)
      , Piece.create Piece.L (3,3)
      ]

piece1 = Piece.create Piece.L (1,1)

main = flow down
  [ plainText "== var_dump() developing 4lyfe! /o\\"
  , plainText " -> rotation 0:"
  , renderShape f <| Piece.project { piece1 | rotation <- 0 }
  , plainText " -> rotation 1"
  , renderShape f <| Piece.project { piece1 | rotation <- 1 }
  , plainText " -> rotation 2"
  , renderShape f <| Piece.project { piece1 | rotation <- 2 }
  , plainText " -> rotation 3"
  , renderShape f <| Piece.project { piece1 | rotation <- 3 }
  , plainText " -> move"
  , renderShape f <| Piece.project <| Piece.move (2,1) piece1
  , plainText "== initial grid:"
  , renderGrid grid
  , plainText "== grid getters:"
  , asText [ getBlock' (0,0), getBlock' (3,0), getBlock' (6,0) ]
  , asText [ isEmpty' (0,0),  isEmpty' (3,0),  isEmpty' (6,0) ]
  , asText [ fits' [(0,0),(1,0),(2,0)] , fits' [(0,0),(1,1)] ]
  , plainText "== grid with full rows removed:"
  , renderGrid <| snd <| Grid.removeFullRows grid
  , plainText "== grid fill 0,0:"
  , renderGridM
    <| Grid.fillEmpty (Full Color.green) (0,0)
    <| Grid.fromLists (List.repeat 3 [e,e,e])
  , plainText "== grid bulk fills from 0,0:"
  , renderGridM
    <| Grid.fillEmpties (Full Color.green) [(0,0),(1,0),(1,1),(2,1)]
    <| Grid.fromLists (List.repeat 4 [e,e,e,e,e])
  ]

-- piece
renderPiece : Piece.Piece -> Element
renderPiece piece =
  renderShape (Full piece.color) (Piece.project piece)

renderShape : Grid.Block -> Piece.Shape -> Element
renderShape block shape =
  let gs = Piece.aabbShapeMax shape
      grid = Grid.initializeEmpty (gs,gs)
  in renderGrid (Grid.setMany block shape grid)

-- grid
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
        Empty  -> blockAsForm Color.lightGray
        Full c -> blockAsForm c
  in collage blockSize blockSize [form]

rowAsEl : Row -> Element
rowAsEl row =
  flow right <| Array.toList <| Array.map blockAsEl row

gridAsEl : Grid -> Element
gridAsEl grid = flow down
  <| Array.toList
  <| Array.map rowAsEl grid
--  <| Array.reverse grid
