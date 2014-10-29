import Window
import Color
import Array
import List

import Board
import View

b = Board.Full Color.blue
g = Board.Full Color.green
r = Board.Full Color.red
o = Board.Full Color.orange
e = Board.Empty

board = Board.fromLists <| List.reverse
  [ [o,e,e,e,e,e]
  , [o,o,e,e,e,r]
  , [e,o,e,e,r,r]
  , [e,e,e,b,b,r]
  , [e,e,b,b,o,g]
  , [e,g,o,o,o,g]
  , [g,g,r,r,b,g]
  , [e,g,r,b,b,g]
  , [e,e,r,b,o,r]
  , [e,e,e,o,o,r]
  , [e,e,e,e,o,r]
  , [e,e,e,e,e,r]
  ]

b2 = Board.set (0,0) (Board.Full Color.yellow) board

bh = Board.height b2

splitAt = 3

render blockSize =
  flow down
    [ plainText <| "Board size: " ++ (show (Board.width board, Board.height board))
    , plainText <| "top " ++ (show splitAt) ++ " lines:"
    , View.renderBoard blockSize <| Board.slice (bh - splitAt) bh b2
    , plainText "rest of the board:"
    , View.renderBoard blockSize <| Board.slice 0 (bh - splitAt) b2
    ]

adaptiveBlockSize = lift (\x -> toFloat (x // (bh+3))) Window.height
main = lift render adaptiveBlockSize

main' = render 30
