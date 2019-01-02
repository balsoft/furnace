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

import Model

import qualified Views.Index
import qualified Views.User

blaze = S.html . renderHtml

nameOf (Entity _ (Person name _)) = name 

main :: IO ()
main = do
  query $ runMigration migrateAll
  scotty 3000 $ do
    S.get "/" $ do
      _users <- query $ selectList [] [LimitTo 10]
      let users = map nameOf _users
      blaze $ Views.Index.render users
    S.post "/user/" $ do
      _name <- S.param "name"
      _age <- S.param "age"
      query $ insert $ Person _name _age
      S.text "Success"
      S.redirect "/"
    S.get "/user/:name" $ do
      _name <- S.param "name"
      _person <- query $ getBy (PersonName _name)
      blaze $ Views.User.render _person
    S.delete "/user/:name" $ do
      name <- S.param "name"
      query $ DB.deleteWhere [PersonNickname ==. name]
      S.redirect "/"
