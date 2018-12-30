module Furnace.Views.Index where

render = do
  html $ do
    body $ do
      h1 "My todo list"
      ul $ do
        li "learn haskell"
        li "make a website"
