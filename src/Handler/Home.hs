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
            @import url("https://fonts.googleapis.com/css?family=Cookie&display=swap");

            *{
                box-sizing: border-box;
            }
            
            @font-face{
                src: "https://fonts.googleapis.com/css?family=Cookie&display=swap";
                font-family: "Cookie", cursive ;
            }
            
            body{
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
                position: relative;
            }
            
            header{
                position: relative;
                top: 25px;
                width: 70vw;
                height: 75px;
                background-color: rgba(25, 26, 25, 0.596);
                color: #E3D081;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 50px;
                align-self: center;
                box-shadow: 0 0 5px 0px #000;    
                font-family: "Lucida Sans", "Lucida Sans Regular", "Lucida Grande", "Lucida Sans Unicode", Geneva, Verdana, sans-serif;
            }
            
            header nav ul{
                list-style:none;
                padding: 0;
                margin: 0;
                display: flex;
                justify-content: space-evenly;
                width: 300px;
            }
            
            header nav ul li{
                text-transform: uppercase;
                font-size: .8em;
            }
            
            .hero{
                position: absolute;
                width: 100vw;
                height: 100vh;
                background-image: url(@{StaticR bg01_jpg});
                background-size: cover;
                display: flex;
                flex-direction: column;
                align-items: center;
                z-index: -1;
            }
            
            .hero-text{
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                text-align: center;
                margin-top: 200px;
                font-family: "Cookie", cursive !important;
                font-size: 2em;
                color: #E3D081;
                width: 500px;
                text-shadow: 0 0 5px #000;
            }
            
            .hero-text p{
                margin-top: -20px;
            }
            
            .button{
                padding: 20px 75px;
                outline: none;
                border: 0;
                text-transform: uppercase;
                color: #E3D081;
                background-color: rgba(235, 101, 52, 0.74);
            }
            
            .button:hover{
                background-color: rgba(235, 101, 52, 0.993);
            }
        |]
        [whamlet|
            <header>
                <div class="logo-container">
                    <h2>Cook Time!
            
            <nav>
                <ul>
                    <li>
                        Home

                    <li>
                        About

                    <li>
                        Dish Search
                    
            <div class="hero">
                <div class="hero-text">
                    <h1>- Cook Time -
                    <p>Search for several different dish recipes and get started cooking!
                    <button class="button">Get Started
                    -- <img src=@{StaticR coelhao_jpg}>
        |]
