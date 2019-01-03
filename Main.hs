{-# LANGUAGE QuasiQuotes, TemplateHaskell, TypeFamilies #-}
{-# LANGUAGE OverloadedStrings, GADTs, FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

{-# LANGUAGE EmptyDataDecls       #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE TypeSynonymInstances #-}

import qualified Web.Scotty as S
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import Data.Text.Lazy (pack)

import Web.Scotty as S
import Text.Blaze.Html5 hiding (map, main)
import Text.Blaze.Html5.Attributes
import Text.Blaze.Html.Renderer.Text
import Control.Monad.IO.Class  (liftIO)
import Control.Monad.Logger
import Database.Persist
import Database.Persist.Sqlite as DB
import Database.Persist.TH
import Control.Monad (forM_)
import Control.Monad.Trans.Reader
import Data.Monoid (mconcat)

import Control.Monad.Trans.Resource (runResourceT, ResourceT)
import Data.Text (Text)
import Data.Time (UTCTime, getCurrentTime)
import Controllers.GPIO

import Control.Concurrent (threadDelay)

-- import Model

import qualified Views.Index
-- import qualified Views.User

blaze = S.html . renderHtml

nameOf (Entity _ (Person name _)) = name 

c = PinController 458

a = c @@ 18
b = c @@ 23

discharge = do
  setState a Input
  setState b Output
  writeValue b Low
  threadDelay 5000

waitForHigh n = do
  result <- readValue b
  if result then n else waitForHigh (n + 1)

charge_time = do
  setState b Input
  setState a Output
  writeValue a High
  return waitForHigh 0

analog_read = do
  discharge
  return charge_time

main = do
  time <- analog_read
  print time
  threadDelay 1000000

