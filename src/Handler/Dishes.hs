{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Dishes where

import Import
-- import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

getDishesR :: Handler Html
getDishesR = do 
    defaultLayout $ do
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
        addStylesheet (StaticR css_variablesEGeneral_css)
        sess <- lookupSession "_NOME"
        $(widgetFile "/headerSearchBar/headerSB")
        $(widgetFile "/categoriesBar/categories")
        $(widgetFile "/dishes/dishes")
