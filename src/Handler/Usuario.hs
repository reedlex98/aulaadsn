{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Usuario where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- renderDivs
formUsu :: Form (Usuario, Text)
formUsu = renderBootstrap $ (,)
    <$> (Usuario 
        <$> areq textField "Nome: " Nothing
        <*> areq emailField "E-mail: " Nothing
        <*> areq passwordField "Senha: " Nothing)
    <*> areq passwordField "Digite Novamente: " Nothing

getUsuarioR :: Handler Html
getUsuarioR = do 
    (widget,_) <- generateFormPost formUsu
    msg <- getMessage
    defaultLayout $ do
        toWidgetHead $(luciusFile "templates/register/register.lucius")
        addScriptRemote "https://code.jquery.com/jquery-3.4.1.min.js"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
        addStylesheet (StaticR css_variablesEGeneral_css)
        toWidgetHead $(luciusFile "templates/headerSearchBar/headerSB.lucius")
        toWidgetHead $(juliusFile "templates/headerSearchBar/headerSB.julius")
        $(widgetFile "/categoriesBar/categories")
        sess <- lookupSession "_NOME"
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
                            <a href="#">
                                <i class="fa fa-user">
                                #{nome}
                        <li>
                            <a href="">
                                <i class="fa fa-book">
                                Envie sua receita
                        <li>
                            <a onclick="deslogar()">
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
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            
            <div class="content-container">
                <div class="register-container">
                    <h1>
                        CADASTRO DE USUARIO
                    
                    <form method=post action=@{UsuarioR}>
                        ^{widget}
                        <input type="submit" value="Cadastrar">
        |]

postUsuarioR :: Handler Html
postUsuarioR = do 
    ((result,_),_) <- runFormPost formUsu
    case result of 
        FormSuccess (usuario,veri) -> do 
            if (usuarioSenha usuario == veri) then do 
                runDB $ insert usuario 
                setMessage [shamlet|
                    <div class="msg success">
                        Usuario cadastrado com sucesso!
                |]
                redirect UsuarioR
            else do 
                setMessage [shamlet|
                    <div class="msg failure">
                        O campo de senha e o de verificação precisam ter o mesmo valor!
                |]
                redirect UsuarioR
        _ -> redirect HomeR





