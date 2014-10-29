import Window
import Color

import Board
import View

b = Board.Full Color.blue
g = Board.Full Color.green
r = Board.Full Color.red
o = Board.Full Color.orange
e = Board.Empty

board = Board.fromLists
  [ [e,e,e,e,b,r]
  , [e,e,e,b,g,o]
  , [e,e,g,g,o,o]
  ]

main = flow down
  [ View.renderBoard 30 <| Board.set (0,0) (Board.Full Color.yellow) board
  , asText (Board.width board, Board.height board)
  ]
