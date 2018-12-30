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


module Views.Index where


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


render :: [String] -> Html
render users = do
  H.html $ do
    H.body $ do
      h1 "Hello world"
      h2 "List of users"
      ul $ do
        forM_ users $ (\user -> li $ do
                          a ! href (stringValue ("/user/" ++ user)) $ do
                            toHtml user)
      h2 "Create new user"
      H.form ! action "/user/" ! method "POST" $ do
        input ! name "name" ! type_ "text"
        br
        input ! name "age" ! type_ "number"
        br
        input ! type_ "submit"
