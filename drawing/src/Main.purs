module Main where

import Prelude

import Data.Maybe (fromJust)
import Data.Traversable (for)
import Data.List (range, List)

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Random (randomRange, RANDOM, randomInt)

import Graphics.Drawing (Drawing, circle, fillColor, filled, render)
import Graphics.Canvas (CANVAS, getCanvasElementById, getContext2D)
import Partial.Unsafe (unsafePartial)

import Color (xyz)

type Point = { x :: Number, y :: Number }

randomPoint :: forall e1. Number -> Number -> Eff (random :: RANDOM | e1) Point
randomPoint x_max y_max =
  do
    x <- randomRange 0.0 x_max
    y <- randomRange 0.0 y_max

    pure { x: x, y: y }

randomPoints :: forall e1. Int -> Int -> Number -> Number -> Eff (random :: RANDOM | e1) (List Point)
randomPoints lower upper min max =
  do
    n <- randomInt lower upper
    for (range 0 n) \_ -> do
      randomPoint min max

makeCircle :: Point -> Drawing
makeCircle p =
  filled (fillColor (xyz 0.8 0.3 1.0)) (circle p.x p.y 5.0)

makeCircles :: List Point -> List Drawing
makeCircles = map makeCircle

main :: Eff (canvas :: CANVAS, random :: RANDOM) (List Unit)
main = do
  mcanvas <- getCanvasElementById "canvas"

  let canvas = unsafePartial (fromJust mcanvas)
  ctx <- getContext2D canvas

  -- TODO: look into the Aff monad for timers?

  points <- randomPoints 5 25 800.0 800.0
  for (makeCircles points) \c -> do
    render ctx c
