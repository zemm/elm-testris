module Main where

import String
import Text
import Color
import Array
import List
import Debug

import Board
import Piece
--import Input


-- Test grid
e = Grid.Empty
f = Grid.Full orange

grid = Grid.fromLists <| reverse
  [ [f,f,f,e]
  , [f,e,e,f]
  , [f,f,f,f]
  , [e,e,e,f]
  ]
--
getBT' bt = Grid.getBlockType bt grid
isEmpty' b = Grid.isEmpty b grid
areEmpty' cs = Grid.areEmpty cs grid
pcs = [ Piece.create Piece.I (3,3)
      , Piece.create Piece.O (3,3)
      , Piece.create Piece.T (3,3)
      , Piece.create Piece.S (3,3)
      , Piece.create Piece.Z (3,3)
      , Piece.create Piece.J (3,3)
      , Piece.create Piece.L (3,3)
      ]

-- TODO: Piece.aabbShapeMax is broken with O-piece
piece1 = Piece.create Piece.I (1,1)

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
  , asText [ getBT' (0,0), getBT' (3,0), getBT' (6,0) ]
  , asText [ isEmpty' (0,0),  isEmpty' (3,0),  isEmpty' (6,0) ]
  , asText [ areEmpty' [(0,0),(1,0),(2,0)] , areEmpty' [(0,0),(1,1)] ]
  , plainText "== grid with full rows removed:"
  , renderGrid <| snd <| Grid.removeFullRows grid
  , plainText "== grid fill 0,0:"
  , renderGridM
    <| Grid.fillEmpty (Grid.Full Color.green) (0,0)
    <| Grid.fromLists (List.repeat 3 [e,e,e])
  , plainText "== grid bulk fills from 0,0:"
  , renderGridM
    <| Grid.fillShapeEmpty (Grid.Full Color.green) [(0,0),(1,0),(1,1),(2,1)]
    <| Grid.fromLists (List.repeat 4 [e,e,e,e,e])
  ]

-- piece
renderTetromino : Piece.Tetromino -> Element
renderTetromino piece =
  renderShape (Grid.Full piece.color) (Piece.project piece)

renderShape : Grid.BlockType -> Grid.Shape -> Element
renderShape blockType shape =
  let gs = Piece.aabbShapeMax shape
      grid = Grid.initializeEmpty (gs,gs)
  in renderGrid (Grid.setShape blockType shape grid)

-- grid
renderGridM : Maybe Grid.Grid -> Element
renderGridM grid = case grid of
  Just g    -> renderGrid g
  otherwise -> leftAligned << monospace <| toText "No grid"

renderGrid : Grid.Grid -> Element
renderGrid grid = leftAligned << monospace << toText <| strGrid grid

strGrid : Grid.Grid -> String
strGrid grid =
  String.join "\n" <| map strRow (reverse (Array.toList grid))

strRow : Grid.Row -> String
strRow row =
  String.join ""
  <| map (\x -> if x == Grid.Empty then "-" else "X")
  <| Array.toList row

blockSize = 40

grad : Color -> Gradient
grad color = radial (-10,10) (blockSize / 2.5) (0,0) 90
  [ (0, color)
  , (1, Color.black)
  ]

blockAsForm : Color -> Form
blockAsForm color = gradient (grad color) (rect blockSize blockSize)

blockAsEl : Grid.BlockType -> Element
blockAsEl blockType =
  let form = case blockType of
        Grid.Empty  -> blockAsForm Color.lightGray
        Grid.Full c -> blockAsForm c
  in collage blockSize blockSize [form]

rowAsEl : Grid.Row -> Element
rowAsEl row =
  flow right <| Array.toList <| Array.map blockAsEl row

gridAsEl : Grid.Grid -> Element
gridAsEl grid = flow down
  <| Array.toList
  <| Array.map rowAsEl grid
--  <| Array.reverse grid
