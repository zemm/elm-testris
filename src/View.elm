module View where

import Color
import Window

import Board

renderBoard : Float -> Board.Grid -> Element
renderBoard side board =
  let w = (ceiling side) * (Board.width board)
      h = (ceiling side) * (Board.height board)
      (fw, fh) = (toFloat w, toFloat h)
      (hw, hh) = (fw / 2, fh / 2)
      hs = side / 2
      (ox, oy) = (-hw + hs, -hh + hs)
      fCenter = filled Color.black <| rect 4 4
      fBoard = move (ox, oy) <| boardForm side board
  in collage w h [fBoard, fCenter]

boardForm : Float -> Board.Grid -> Form
boardForm side board =
  let iter = \i r -> moveY ((toFloat i)*side) <| rowForm side r
  in group <| Board.toList <| Board.indexedMap iter board

rowForm : Float -> Board.Row -> Form
rowForm side blocks =
  let iter = \i b -> moveX ((toFloat i)*side) <| blockForm side b
  in group <| Board.toList <| Board.indexedMap iter blocks

blockForm : Float -> Board.BlockType -> Form
blockForm side block =
  case block of
    Board.Full c -> fullBlockForm side c
    Board.Empty  -> emptyBlockForm side Color.lightGray

emptyBlockForm : Float -> Color -> Form
emptyBlockForm side color =
  filled color <| rect side side

fullBlockForm : Float -> Color -> Form
fullBlockForm side color =
  let colors = [(0, color), (1, Color.black)]
      grad = radial (0,0) (side/3.5) (-30,30) 70 colors
  in gradient grad <| (rect side side)
