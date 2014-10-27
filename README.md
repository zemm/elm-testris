INCOMPLETE TESTS - UNDER CONSTRUCTION!
===

Elm-TestTris
---

For a wobbly learning experience.


Standards
---

Try to remember to follow SRS http://tetris.wikia.com/wiki/SRS


Todo
---

- "Random bag" generator http://tetris.wikia.com/wiki/Random_Generator
- Check how ticker should work


Deciding the data structure
---

List
  + Clear full rows (has all)
  + Render in order
  - Collides with shape (O(n) per dimension)
  - Insert shape
  + most functions
  + Bounds check

Array
  x Clear full rows (no `all`, not lazy when implemented with fold)
  + Render in order
  x Collides with shape (O(log n)? per dimension)
  x Insert shape
  x Printing (requires toList >> reverse with rows)
  + Bounds check

Dict
  - Clear full rows
  - Render in order
  + Collides with shape (`intersect`, O(log n)                                   )
  + Insert shape (`union`)
  - Bounds check

-> Let's `Array Array` for now
