import Window
import Color

import Grid
import View

b = Grid.Full Color.blue
g = Grid.Full Color.green
r = Grid.Full Color.red
o = Grid.Full Color.orange
e = Grid.Empty

board = Grid.fromLists
  [ [e,e,e,e,b,r]
  , [e,e,e,b,g,o]
  , [e,e,g,g,o,o]
  ]

main = flow down
  [ View.renderBoard 30 <| Grid.set (0,0) (Grid.Full Color.yellow) board
  , asText (Grid.width board, Grid.height board)
  ]
