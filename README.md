WIP - INCOMPLETE
===

...and probably will be left as such
---


Elm-TestTris
---

For a wobbly learning experience.


Standards
---

```
Try to remember to follow
http://tetris.wikia.com/wiki/Tetris_Guideline
http://tetris.wikia.com/wiki/SRS
http://tetris.wikia.com/wiki/Guideline_compliant_game_differences
http://tetrisconcept.net/wiki/SRS
..or ARS?
http://tetrisconcept.net/wiki/ARS
```

Todo
---

```
Random
 - separate shape from piece for nicer functions


At least
[/] Rotations
[/] Moving
[/] Exploding rows
[ ] Spawn & Board - Playfield is 10 cells wide and at least 22 cells tall, where rows above 20 are hidden or obstructed by the field frame
[ ] Graphics rending
[ ] Score keeping
[ ] Game model
[ ] Reset
[ ] Keyboard input

Possibly maybe
[ ] http://tetris.wikia.com/wiki/Ghost_piece
[ ] 60fps http://tetris.wikia.com/wiki/TGM_legend#Frame
[ ] Gravity http://tetris.wikia.com/wiki/Drop
[ ] Soft drop http://tetris.wikia.com/wiki/Drop
[ ] Hard drop http://tetris.wikia.com/wiki/Drop
[ ] Lock delay http://tetris.wikia.com/wiki/Lock_delay
[ ] http://tetris.wikia.com/wiki/Random_Generator
[ ] Hold piece
[ ] Preview board

Propably not
[ ] http://tetris.wikia.com/wiki/Wall_kick
[ ] http://tetris.wikia.com/wiki/Floor_kick
[ ] http://tetris.wikia.com/wiki/Twist

```


Deciding the board data structure
---

```
List
  + Clear full rows (has all)
  + Render in order
  - Collides with shape (O(n) per dimension)
  - Insert shape
  + most functions
  + Bounds check

Array
  ~ Clear full rows (no `all`, not lazy when implemented with fold)
  + Render in order
  ~ Collides with shape (O(log n)? per dimension)
  ~ Insert shape
  ~ Printing (requires toList >> reverse with rows)
  + Bounds check

Dict
  - Clear full rows
  - Render in order
  + Collides with shape (`intersect`, O(log n)                                   )
  + Insert shape (`union`)
  - Bounds check
```

-> Let's `Array Array` for now


License
---

WTFPL2
