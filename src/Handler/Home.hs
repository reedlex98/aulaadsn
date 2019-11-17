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
        toWidgetHead $(luciusFile "templates/general/general.lucius")
        toWidgetHead $(luciusFile "templates/general/consentment-banner.lucius")
        toWidgetHead $(juciusFile "templates/general/consentment-banner.jucius")
        $(widgetFile "/header/header")
        $(widgetFile "/hero/hero")
