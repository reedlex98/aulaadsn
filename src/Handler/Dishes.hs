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
        headerSize <- full
        toWidgetHead $(luciusFile "templates/general/general.lucius")
        $(widgetFile "/header/header")
        $(widgetFile "/dishes/dishes")
