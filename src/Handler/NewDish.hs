{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.NewDish where

import Import
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql
import Text.Lucius
import Text.Julius

-- renderDivs
formReceita :: Form Receita 
formReceita = renderBootstrap $ Receita 
        <$> areq textField "Nome: " Nothing
        <*> areq textareaField "Ingredientes: " Nothing
        <*> areq textareaField "Modo de preparo: " Nothing
        <*> areq intField "Tempo de preparo: " Nothing


getNewDishR :: Handler Html
getNewDishR = do 
    (widget,enctype) <- generateFormPost formReceita 
    defaultLayout $ do 
        toWidgetHead $(luciusFile "templates/register/register.lucius")
        addStylesheetRemote "https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
        addStylesheet (StaticR css_variablesEGeneral_css)
        toWidgetHead $(luciusFile "templates/headerSearchBar/headerSB.lucius")
        $(widgetFile "/categoriesBar/categories")
        setTitle "Cook Time! Porque a hora de cozinhar é agora | Nova Receita"
        msg <- getMessage
        sess <- lookupSession "_NOME"
        [whamlet|
            $maybe nome <- sess
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
                        Nova Receita
                        
                    <form method=post action=@{NewDishR}>
                        ^{widget}
                        <input type="submit" value="Cadastrar">
            $nothing
                redirect EntrarR
        |]

postNewDishR :: Handler Html
postNewDishR = do 
    ((result,_),_) <- runFormPost formReceita
    case result of 
        FormSuccess receita -> do 
            runDB $ insert receita
            setMessage [shamlet|
                <div class="msg success">
                    Receita enviada com sucesso
            |]
            redirect NewDishR
        _ -> redirect HomeR

-- getListProdR :: Handler Html 
-- getListProdR = do 
--     -- select * from Produto order by produto.nome
--     produtos <- runDB $ selectList [] [Asc ProdutoNome]
--     defaultLayout $ do 
--         $(whamletFile "templates/produtos.hamlet")

-- postApagarProdR :: ProdutoId -> Handler Html
-- postApagarProdR pid = do 
--     _ <- runDB $ get404 pid
--     runDB $ delete pid
--     redirect ListProdR