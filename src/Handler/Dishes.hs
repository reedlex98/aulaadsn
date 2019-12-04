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
        -- $(widgetFile "/headerSearchBar/headerSB")
        toWidgetHead $(luciusFile "templates/headerSearchBar/headerSB.lucius")
        [whamlet|
            <nav class="navigation">
            <div class="logo">
                <strong>
                    Cook Time!
            <div class="search-form">
                <input class="search-input" name="search-recipe" type="text" placeholder="Encontre uma receita...">
                <button class="search-button">
                    <i class="fa fa-search">
            <ul class="nav-buttons">
                $maybe nome <- sess
                    <li>
                        <a href="">
                            <i class="fa fa-book">
                            Envie sua receita
                    <li>
                        <a href=@{SairR}>
                            <i class="fa fa-sign-out">
                            Sair
                $nothing 
                    <li>
                        <a href=@{UsuarioR}>
                            <i class="fa fa-book">
                            Envie sua receita
                    <li>
                        <a href=@{UsuarioR}>
                            <i class="fa fa-user-plus">
                            Cadastre-se
                    <li>
                        <a href=@{EntrarR}>
                            <i class="fa fa-sign-in">
                            Entrar
        |]
        $(widgetFile "/categoriesBar/categories")
        $(widgetFile "/dishes/dishes")
