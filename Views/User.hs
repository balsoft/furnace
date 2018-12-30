

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

module Views.User where

import qualified Web.Scotty as S
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import Data.Text.Lazy (pack)

import Web.Scotty as S
import Text.Blaze.Html5 hiding (map, main)
import Text.Blaze.Html5.Attributes
import Text.Blaze.Html.Renderer.Text

import Model

import Database.Persist

suffix :: Int -> String
suffix n | n == 1 = ""
         | otherwise = "s"


render (Just (Entity _ (Person name age))) = H.html $ do
  H.head $ do
    H.title $ toHtml ("Personal page of " ++ name)
  H.body $ do
    H.main $ do 
      h1 $ toHtml ("Personal page of " ++ name)
      p $ toHtml (name ++ " is " ++ show age ++ " year" ++ (suffix age) ++ " old")
render Nothing = H.html $ do
  H.head $ do
    H.title "Person not found"
  H.body $ do
    H.main $ do
      h1 "Person not found!"
 
