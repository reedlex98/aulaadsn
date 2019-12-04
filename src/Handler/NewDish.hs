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
        msg <- getMessage
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            
            <h1>
                CADASTRO DE PRODUTOS
                
            <form method=post action=@{NewDishR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postNewDishR :: Handler Html
postNewDishR = do 
    ((result,_),_) <- runFormPost formReceita
    case result of 
        FormSuccess receita -> do 
            runDB $ insert receita
            setMessage [shamlet|
                <h2>
                    PRODUTO INSERIDO COM SUCESSO
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