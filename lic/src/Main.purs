module Main where

import Prelude

import Data.Int (toNumber, floor)
import Data.Maybe (fromJust)
import Data.Traversable (for)
import Data.List (List, range, zipWith, concat)
import Data.Unfoldable (replicateA)

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Random (randomBool, RANDOM)

import Graphics.Drawing (Drawing, circle, fillColor, filled, render)
import Graphics.Canvas (CANVAS, getCanvasElementById, getContext2D)
import Partial.Unsafe (unsafePartial)

import Color (xyz)

data NoiseColor = Black | White | None
type Point = { x :: Number, y :: Number, color :: NoiseColor }

makePoint :: Number -> Number -> Number -> Number -> NoiseColor -> Point
makePoint xp yp w h cp = { x : xp * w, y : yp * h, color : cp }

replicateGrid w h f = replicateA h (replicateA w f)

whiteNoise :: forall e. Eff (random :: RANDOM | e) NoiseColor
whiteNoise =
  do
    flip <- randomBool
    if flip
      then pure Black
      else pure White

whiteNoiseRect :: forall e. Int -> Int -> Eff (random :: RANDOM | e) (List (List NoiseColor))
whiteNoiseRect w h = replicateGrid w h whiteNoise

makeCircle :: Number -> Point -> Drawing
makeCircle r p =
  let color = case p.color of
        Black -> xyz 0.0 0.0 0.0
        White -> xyz 0.5 0.5 0.5
        None  -> xyz 0.0 0.0 1.0
  in
    filled (fillColor color) (circle p.x p.y r)

makeCircles :: Number -> List Point -> List Drawing
makeCircles r = map (makeCircle r)

makeGrid :: Int -> Int -> Int -> Int -> List (List Point)
makeGrid w h pixel_w pixel_h =
  map (\y -> map (\x -> makePoint (toNumber x) (toNumber y) (toNumber pixel_w) (toNumber pixel_h) None) (range 0 w)) (range 0 h)

updateRow :: List NoiseColor -> List Point -> List Point
updateRow = zipWith (\c -> \p -> p { color = c})

updateColors :: List (List NoiseColor) -> List (List Point) -> List (List Point)
updateColors = zipWith updateRow

main :: Eff (canvas :: CANVAS, random :: RANDOM) (List Unit)
main = do
  mcanvas <- getCanvasElementById "canvas"

  let canvas = unsafePartial (fromJust mcanvas)
  ctx <- getContext2D canvas

  -- todo: trampoline
  let grid_x = 1000
  let grid_y = 1000

  let pixel_dimension = 20
  let r = (toNumber pixel_dimension) / 2.0

  let sigh  = (toNumber grid_x) / (toNumber pixel_dimension)
  let sigh2 = (toNumber grid_x) / (toNumber pixel_dimension)

  let x_count = floor ((toNumber grid_x) / (toNumber pixel_dimension))
  let y_count = floor ((toNumber grid_x) / (toNumber pixel_dimension))

  colors <- whiteNoiseRect x_count y_count

  let points = updateColors colors (makeGrid x_count y_count pixel_dimension pixel_dimension)
  for (makeCircles r (concat points)) \c -> do
    render ctx c
