module Grid where

import Array
import List

-- @TODO: flip arguments so that data is last

type Coord = (Int,Int)
data Block = Empty | Full Color
type Row = Array.Array Block
type Grid = Array.Array Row

initializeEmpty : Coord -> Grid
initializeEmpty (width, height) =
  Array.repeat height <| Array.repeat width Empty

fromLists : [[Block]] -> Grid
fromLists lists =
  Array.fromList <| List.map Array.fromList lists

toLists : Grid -> [[Block]]
toLists grid =
    Array.toList <| Array.map Array.toList grid

isFullRow : Row -> Bool
isFullRow row =
  let iter = \f x acc -> if acc then f x else acc
      all f a = Array.foldl (iter f) True a
  in all (\x -> not (x == Empty)) row

clearRow : Row -> Row
clearRow row = Array.repeat (Array.length row) Empty

removeFullRows : Grid -> (Int, Grid)
removeFullRows grid =
  let (fullRows, nonFullRows) = groupByFullness grid
      newRows = Array.map clearRow fullRows
      fullRowCount = Array.length fullRows
  in (fullRowCount, Array.append nonFullRows newRows)

groupByFullness : Grid -> (Grid, Grid)
groupByFullness grid =
  let grouper row acc =
        if | isFullRow row -> (Array.push row (fst acc), snd acc)
           | otherwise     -> (fst acc, Array.push row (snd acc))
  in Array.foldl grouper (Array.empty, Array.empty) grid

width : Grid -> Int
width grid =
  let firstRow = Array.get 0 grid
  in case firstRow of
    Just row -> Array.length row
    Nothing  -> 0

height : Grid -> Int
height grid = Array.length grid

getBlock : Coord -> Grid -> Maybe Block
getBlock coord grid =
  let row = Array.get (snd coord) grid
  in case row of
     Just r  -> Array.get (fst coord) r
     Nothing -> Nothing

isEmpty : Coord -> Grid -> Bool
isEmpty coord grid =
  let block = getBlock coord grid
  in case block of
    Just Empty -> True
    otherwise  -> False

areEmpty : [Coord] -> Grid -> Bool
areEmpty coords grid = List.all (\c -> isEmpty c grid) coords

contains : Coord -> Grid -> Bool
contains coord grid =
  let block = getBlock coord grid
  in case block of
    Just _  -> True
    Nothing -> False

-- setters that always succeeds, does not modify if
-- out of range (default Array set functionality)

set : Block -> Coord -> Grid -> Grid
set block coord grid =
  let x = fst coord
      y = snd coord
      oldRow = Array.get y grid
  in case oldRow of
    Just row -> Array.set y (Array.set x block row) grid
    Nothing  -> grid

setMany : Block -> [Coord] -> Grid -> Grid
setMany block coords grid =
  let iter = \block coord g -> set block coord g
  in List.foldl (iter block) grid coords

-- setters that fail if targets are not empty or are out of bounds
-- Could be generalized with a predicate

fillEmpty : Block -> Coord -> Grid -> Maybe Grid
fillEmpty block coord grid =
  let x = fst coord
      y = snd coord
      oldRow = Array.get y grid
      newRow = case oldRow of
        Just row -> fillEmptyInRow x block row
        Nothing  -> Nothing
  in case newRow of
    Just nr -> Just (Array.set y nr grid)
    Nothing -> Nothing

fillEmptyMany : Block -> [Coord] -> Grid -> Maybe Grid
fillEmptyMany block coords grid =
  List.foldl (fillEmptyM block) (Just grid) coords

fillEmptyM : Block -> Coord -> Maybe Grid -> Maybe Grid
fillEmptyM block coord grid =
  case grid of
    Just g  -> fillEmpty block coord g
    Nothing -> Nothing

fillEmptyInRow : Int -> Block -> Row -> Maybe Row
fillEmptyInRow ndx block row =
  let oldBlock = Array.get ndx row
  in case oldBlock of
    Just Empty -> Just (Array.set ndx block row)
    otherwise  -> Nothing
