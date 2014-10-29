module Main where

import String
import Text
import Color
import Array
import List
import Debug

import Board
import Tetromino
--import Input


-- Test grid
e = Board.Empty
f = Board.Full orange

grid = Board.fromLists <| reverse
  [ [f,f,f,e]
  , [f,e,e,f]
  , [f,f,f,f]
  , [e,e,e,f]
  ]
--
getBT' bt = Board.getBlockType bt grid
isEmpty' b = Board.isEmpty b grid
shapeFits' cs = Board.shapeFits cs grid
pcs = [ Tetromino.create Tetromino.I (3,3)
      , Tetromino.create Tetromino.O (3,3)
      , Tetromino.create Tetromino.T (3,3)
      , Tetromino.create Tetromino.S (3,3)
      , Tetromino.create Tetromino.Z (3,3)
      , Tetromino.create Tetromino.J (3,3)
      , Tetromino.create Tetromino.L (3,3)
      ]

piece1 = Tetromino.create Tetromino.O (1,1)

main = flow down
  [ plainText "== var_dump() developing 4lyfe! /o\\"
  , plainText " -> rotation 0:"
  , renderShape f <| Tetromino.project { piece1 | rotation <- 0 }
  , plainText " -> rotation 1"
  , renderShape f <| Tetromino.project { piece1 | rotation <- 1 }
  , plainText " -> rotation 2"
  , renderShape f <| Tetromino.project { piece1 | rotation <- 2 }
  , plainText " -> rotation 3"
  , renderShape f <| Tetromino.project { piece1 | rotation <- 3 }
  , plainText " -> move"
  , renderShape f <| Tetromino.project <| Tetromino.move (2,1) piece1
  , plainText "== initial grid:"
  , renderGrid grid
  , plainText "== grid getters:"
  , asText [ getBT' (0,0), getBT' (3,0), getBT' (6,0) ]
  , asText [ isEmpty' (0,0),  isEmpty' (3,0),  isEmpty' (6,0) ]
  , asText [ shapeFits' [(0,0),(1,0),(2,0)] , shapeFits' [(0,0),(1,1)] ]
  , plainText "== grid with full rows removed:"
  , renderGrid <| snd <| Board.removeFullRows grid
  , plainText "== grid fill 0,0:"
  , renderGridM
    <| Board.fillEmpty (0,0) (Board.Full Color.green)
    <| Board.fromLists (List.repeat 3 [e,e,e])
  , plainText "== grid bulk fills from 0,0:"
  , renderGridM
    <| Board.fillShapeEmpty [(0,0),(1,0),(1,1),(2,1)] (Board.Full Color.green)
    <| Board.fromLists (List.repeat 4 [e,e,e,e,e])
  ]

-- piece
renderTetromino : Tetromino.Tetromino -> Element
renderTetromino piece =
  renderShape (Board.Full piece.color) (Tetromino.project piece)

renderShape : Board.BlockType -> Board.Shape -> Element
renderShape blockType shape =
  let gs = Tetromino.aabbMax shape
      grid = Board.initializeEmpty (gs,gs)
  in renderGrid (Board.setShape shape blockType grid)

-- grid
renderGridM : Maybe Board.Grid -> Element
renderGridM grid = case grid of
  Just g    -> renderGrid g
  otherwise -> leftAligned << monospace <| toText "No grid"

renderGrid : Board.Grid -> Element
renderGrid grid = leftAligned << monospace << toText <| strGrid grid

strGrid : Board.Grid -> String
strGrid grid =
  String.join "\n" <| map strRow (reverse (Array.toList grid))

strRow : Board.Row -> String
strRow row =
  String.join ""
  <| map (\x -> if x == Board.Empty then "-" else "X")
  <| Array.toList row

blockSize = 40

grad : Color -> Gradient
grad color = radial (-10,10) (blockSize / 2.5) (0,0) 90
  [ (0, color)
  , (1, Color.black)
  ]

blockAsForm : Color -> Form
blockAsForm color = gradient (grad color) (rect blockSize blockSize)

blockAsEl : Board.BlockType -> Element
blockAsEl blockType =
  let form = case blockType of
        Board.Empty  -> blockAsForm Color.lightGray
        Board.Full c -> blockAsForm c
  in collage blockSize blockSize [form]

rowAsEl : Board.Row -> Element
rowAsEl row =
  flow right <| Array.toList <| Array.map blockAsEl row

gridAsEl : Board.Grid -> Element
gridAsEl grid = flow down
  <| Array.toList
  <| Array.map rowAsEl grid
--  <| Array.reverse grid
