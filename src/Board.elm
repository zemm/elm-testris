module Board where

import Array
import List

-- @TODO: flip arguments so that data is last

type Pos2 = (Int,Int)

type Shape = [Pos2]

data BlockType = Empty | Full Color

type Row = Array.Array BlockType

type Grid = Array.Array Row

-- Alias default functions for selected internal datatype

map = Array.map

indexedMap = Array.indexedMap

toList = Array.toList

all f a =
  let iter = \f x acc -> if acc then f x else acc
  in Array.foldl (iter f) True a

--

initializeEmpty : Pos2 -> Grid
initializeEmpty (width, height) =
  Array.repeat height <| Array.repeat width Empty

fromLists : [[BlockType]] -> Grid
fromLists lists =
  Array.fromList <| List.map Array.fromList lists

toLists : Grid -> [[BlockType]]
toLists grid =
    Array.toList <| Array.map Array.toList grid

isFullRow : Row -> Bool
isFullRow row = all (\x -> not (x == Empty)) row

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

getBlockType : Pos2 -> Grid -> Maybe BlockType
getBlockType coord grid =
  let row = Array.get (snd coord) grid
  in case row of
     Just r  -> Array.get (fst coord) r
     Nothing -> Nothing

isEmpty : Pos2 -> Grid -> Bool
isEmpty coord grid =
  let blockType = getBlockType coord grid
  in case blockType of
    Just Empty -> True
    otherwise  -> False

areEmpty : Shape -> Grid -> Bool
areEmpty coords grid = List.all (\c -> isEmpty c grid) coords

contains : Pos2 -> Grid -> Bool
contains coord grid =
  let blockType = getBlockType coord grid
  in case blockType of
    Just _  -> True
    Nothing -> False

-- setters that always succeeds, does not modify if
-- out of range (default Array set functionality)

set : Pos2 -> BlockType -> Grid -> Grid
set coord blockType grid =
  let x = fst coord
      y = snd coord
      oldRow = Array.get y grid
  in case oldRow of
    Just row -> Array.set y (Array.set x blockType row) grid
    Nothing  -> grid

setShape : Shape -> BlockType -> Grid -> Grid
setShape shape blockType grid =
  let iter = \blockType coord g -> set coord blockType g
  in List.foldl (iter blockType) grid shape

-- setters that fail if targets are not empty or are out of bounds
-- Could be generalized with a predicate

fillEmpty : BlockType -> Pos2 -> Grid -> Maybe Grid
fillEmpty blockType coord grid =
  let x = fst coord
      y = snd coord
      oldRow = Array.get y grid
      newRow = case oldRow of
        Just row -> fillEmptyInRow x blockType row
        Nothing  -> Nothing
  in case newRow of
    Just nr -> Just (Array.set y nr grid)
    Nothing -> Nothing

fillShapeEmpty : BlockType -> Shape -> Grid -> Maybe Grid
fillShapeEmpty blockType coords grid =
  List.foldl (fillEmptyM blockType) (Just grid) coords

fillEmptyM : BlockType -> Pos2 -> Maybe Grid -> Maybe Grid
fillEmptyM blockType coord grid =
  case grid of
    Just g  -> fillEmpty blockType coord g
    Nothing -> Nothing

fillEmptyInRow : Int -> BlockType -> Row -> Maybe Row
fillEmptyInRow ndx blockType row =
  let oldBlockType = Array.get ndx row
  in case oldBlockType of
    Just Empty -> Just (Array.set ndx blockType row)
    otherwise  -> Nothing
