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
            ul{
                list-style:none;
            }
            li{
                display: inline-block
            }
        |]
        [whamlet|
            <h1>
                OLA MUNDO
            <ul>
                <li>
                    <a href=@{Page1R}>
                        Pagina 1
                <li>
                    <a href=@{Page2R}>
                        Pagina 2
            <button onclick="ola()" class="btn btn-danger">
                KO
            <img src=@{StaticR coelhao_jpg}>
        |]
