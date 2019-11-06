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

getPage1R :: Handler Html
getPage1R  = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(juliusFile "templates/page1.julius")
        toWidgetHead $(luciusFile "templates/page1.lucius")
        $(whamletFile "templates/page1.hamlet")

getPage2R :: Handler Html
getPage2R  = do
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        $(whamletFile "templates/page2.hamlet")

getHomeR :: Handler Html
getHomeR = do 
    defaultLayout $
        do
        -- remoto
        -- addScriptRemote "https://code.jquery.com/jquery-3.4.1.slim.js"
        addStylesheet (StaticR css_indexPage_css)
        -- local
        toWidgetHead $(luciusFile "templates/indexPage.lucius")
        $(whamletFile "templates/indexPage.hamlet")