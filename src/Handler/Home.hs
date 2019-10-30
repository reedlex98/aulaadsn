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

getHomeR :: Handler Html
getHomeR = do 
    defaultLayout $
        do
        -- remoto
        addScriptRemote "https://code.jquery.com/jquery-3.4.1.slim.js"
        addStylesheet (StaticR css_bootstrap_css)
        -- local
        toWidgetHead [julius|
            function ola(){
                alert("Ola Mundo")
            }
        |]
        toWidgetHead [lucius|
            h1{
                color: red;
            }
        |]
        [whamlet|
            <h1>
                OLA MUNDO
            <button onclick="ola()" class="btn btn-danger">
                KO
        |]
