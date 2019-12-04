{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- renderDivs
formLogin :: Form (Text, Text)
formLogin = renderBootstrap $ (,)
    <$> areq emailField "E-mail: " Nothing
    <*> areq passwordField "Senha: " Nothing

getEntrarR :: Handler Html
getEntrarR = do 
    (widget,_) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ do
        toWidgetHead $(luciusFile "templates/register/register.lucius")
        setTitle "Cook Time! Porque a hora de cozinhar é agora | Login"
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"  
        addStylesheet (StaticR css_variablesEGeneral_css)
        toWidgetHead $(luciusFile "templates/headerSearchBar/headerSB.lucius")
        $(widgetFile "/categoriesBar/categories")
        sess <- lookupSession "_NOME"
        [whamlet|
            <nav class="navigation">
                <div class="logo">
                    <div class="logo">
                        <a href=@{DishesR}>
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
                            <a href=@{NewDishR}>
                                <i class="fa fa-book">
                                Envie sua receita
                        <li>
                            <form action=@{SairR} method="POST">
                                <button>
                                    <i class="fa fa-sign-out">
                                    Sair
                    $nothing 
                        <li>
                            <a href=@{EntrarR}>
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
                        Login
                    
                    <form method=post action=@{EntrarR}>
                        ^{widget}
                        <input type="submit" value="Entrar">
        |]

postEntrarR :: Handler Html
postEntrarR = do 
    ((result,_),_) <- runFormPost formLogin
    case result of 
        FormSuccess ("root@root.com","root125") -> do 
            setSession "_NOME" "admin"
            redirect AdminR
        FormSuccess (email,senha) -> do 
           -- select * from usuario where email=digitado.email
           usuario <- runDB $ getBy (UniqueEmailRest email)
           case usuario of 
                Nothing -> do 
                    setMessage [shamlet|
                        <div class="msg failure">
                            Não conseguimos encontrar o seu e-mail!
                    |]
                    redirect EntrarR
                Just (Entity _ usu) -> do 
                    if (usuarioSenha usu == senha) then do
                        setSession "_NOME" (usuarioNome usu)
                        redirect DishesR
                    else do 
                        setMessage [shamlet|
                            <div class="msg failure">
                                A senha não é válida!
                        |]
                        redirect EntrarR 
        _ -> redirect DishesR

postSairR :: Handler Html 
postSairR = do 
    deleteSession "_NOME"
    redirect HomeR

getAdminR :: Handler Html
getAdminR = do 
    defaultLayout [whamlet|
        <h1>
            Bem-vindo!
    |]



