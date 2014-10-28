module Grid where

import Array
import List

-- @TODO: flip arguments so that data is last

type Coord = (Int,Int)
data Block = Empty | Full Color
type Row = Array.Array Block
type Grid = Array.Array Row

initializeEmpty : Int -> Int -> Grid
initializeEmpty width height =
  Array.repeat height <| Array.repeat width Empty

fromLists : [[Block]] -> Grid
fromLists lists =
  Array.fromList <| List.map Array.fromList lists

toLists : Grid -> [[Block]]
toLists grid =
    Array.toList <| Array.map Array.toList grid

all : (a -> Bool) -> Array.Array a -> Bool
all f a =
  let iter = \f x acc -> if acc then f x else acc
  in Array.foldl (iter f) True a

isFullRow : Row -> Bool
isFullRow row = all (\x -> not (x == Empty)) row

clearRow : Row -> Row
clearRow row = Array.repeat (Array.length row) Empty

fullnessGrouper : Row -> (Grid,Grid) -> (Grid,Grid)
fullnessGrouper row acc =
  if | isFullRow row -> (Array.push row (fst acc), snd acc)
     | otherwise     -> (fst acc, Array.push row (snd acc))

groupByFullness : Grid -> (Grid, Grid)
groupByFullness grid =
  Array.foldl fullnessGrouper (Array.empty, Array.empty) grid

removeFullRows : Grid -> (Int, Grid)
removeFullRows grid =
  let (fullRows, nonFullRows) = groupByFullness grid
      newRows = Array.map clearRow fullRows
      fullRowCount = Array.length fullRows
  in (fullRowCount, Array.append nonFullRows newRows)

width : Grid -> Int
width grid =
  let firstRow = Array.get 0 grid
  in case firstRow of
    Just row -> Array.length row
    Nothing  -> 0

height : Grid -> Int
height grid = Array.length grid

getBlock : Grid -> Coord -> Maybe Block
getBlock grid coord =
  let row = Array.get (snd coord) grid
  in case row of
     Just r  -> Array.get (fst coord) r
     Nothing -> Nothing

isEmpty : Grid -> Coord -> Bool
isEmpty grid coord =
  let block = getBlock grid coord
  in case block of
    Just Empty -> True
    otherwise  -> False

fits : Grid -> [Coord] -> Bool
fits grid coords = List.all (isEmpty grid) coords

contains : Coord -> Grid -> Bool
contains coord grid =
  let block = getBlock grid coord
  in case block of
    Just _  -> True
    Nothing -> False

-- Versions of set that always succeeds, does not modify if
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

-- Empty-checking versions; might not be needed, or they could be
-- generalized with a predicate:

fillEmptyInRow : Int -> Block -> Row -> Maybe Row
fillEmptyInRow ndx block row =
  let oldBlock = Array.get ndx row
  in case oldBlock of
    Just Empty -> Just (Array.set ndx block row)
    otherwise  -> Nothing

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

fillEmptyM : Block -> Coord -> Maybe Grid -> Maybe Grid
fillEmptyM block coord grid =
  case grid of
    Just g  -> fillEmpty block coord g
    Nothing -> Nothing

fillEmpties : Block -> [Coord] -> Grid -> Maybe Grid
fillEmpties block coords grid =
  List.foldl (fillEmptyM block) (Just grid) coords

