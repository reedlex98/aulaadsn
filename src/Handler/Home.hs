{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
-- import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

getHomeR :: Handler Html
getHomeR = do 
    defaultLayout $ do
        $(luciusFile "/templates/general/general.lucius")
        $(widgetFile "/header/header")
        $(widgetFile "/hero/hero")