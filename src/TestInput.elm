import Window
import Keyboard
import Color
import Array
import List

import Board
import Tetromino
import View
import Input

b = Board.Full Color.blue
g = Board.Full Color.green
r = Board.Full Color.red
o = Board.Full Color.orange
e = Board.Empty

board = Board.fromLists <| List.reverse
  [ [e,e,e,e,e,e]
  , [e,e,e,e,e,e]
  , [e,e,e,e,e,e]
  , [e,e,e,e,e,e]
  , [e,e,e,e,e,e]
  , [e,e,e,e,e,e]
  , [e,e,e,e,e,e]
  , [e,e,o,e,e,e]
  , [e,o,o,e,r,r]
  , [g,b,o,e,r,b]
  , [g,b,b,e,r,b]
  , [g,g,b,e,b,b]
  ]

b2 = Board.set (0,0) (Board.Full Color.yellow) board

bw = Board.width b2
bh = Board.height b2

piece = Tetromino.create Tetromino.I (bw//2, bh//2)

splitAt = 3

render piece blockSize =
  let b3 = Board.setShape (Tetromino.project piece) (Board.Full piece.color) b2
  in flow down
    [ plainText <| "Board size: " ++ (show (bw, bh))
    , plainText <| "top " ++ (show splitAt) ++ " lines:"
    , View.renderBoard blockSize <| Board.slice (bh - splitAt) bh b3
    , plainText "rest of the board:"
    , View.renderBoard blockSize <| Board.slice 0 (bh - splitAt) b3
    ]

adaptiveBlockSize = lift (\x -> toFloat (x // (bh+3))) Window.height
xmain = lift (render piece) adaptiveBlockSize

step action piece =
  case action of
    Just (Input.Move (Input.Left))  -> Tetromino.moveLeft piece
    Just (Input.Move (Input.Right)) -> Tetromino.moveRight piece
    Just (Input.SoftDrop)           -> Tetromino.moveDown piece
    Just (Input.Rotate (Input.CW))  -> Tetromino.rotateCW piece
    otherwise                       -> piece

main = lift (\p -> render p 30) <| foldp step piece Input.input
