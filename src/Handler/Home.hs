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
    defaultLayout $
        do
        -- remoto
        -- addScriptRemote "https://code.jquery.com/jquery-3.4.1.slim.js"
        addStylesheet (StaticR css_bootstrap_css)
        -- addStylesheet (StaticR css_indexPage_css)
        $(widgetFile "/home/home")