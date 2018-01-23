module Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE, log)

import Control.Monad.Aff (delay, Fiber, launchAff, Milliseconds(..))

main :: forall e. Eff (console :: CONSOLE | e) (Fiber (console :: CONSOLE | e) Unit)
main = launchAff do
  liftEff $ log "About to pause for a moment..."
  delay (Milliseconds 5000.0)
  liftEff $ log "Pause over!"
