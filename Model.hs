
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

module Model where


import Control.Monad.Logger
import Database.Persist
import Database.Persist.Sqlite as DB
import Database.Persist.TH
import Control.Monad (forM_)
import Control.Monad.Trans.Reader
import Data.Monoid (mconcat)

import Control.Monad.IO.Class  (liftIO)
import Control.Monad.Trans.Resource (runResourceT, ResourceT)
import Data.Text (Text)
import Data.Time (UTCTime, getCurrentTime)


share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Person
    nickname String
    PersonName nickname
    age Int
    deriving Show
BlogPost
    title String
    authorId PersonId
    deriving Show
|]

asSqlBackendReader :: ReaderT SqlBackend m a -> ReaderT SqlBackend m a
asSqlBackendReader = Prelude.id

query action = liftIO $ runSqlite "test.sqlite" . asSqlBackendReader $ do action
