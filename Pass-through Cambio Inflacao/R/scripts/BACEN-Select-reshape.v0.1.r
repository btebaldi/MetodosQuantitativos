## --- Bibliotecas R
library(RODBC);

## --- Programa Principal

databasefile = "../database/MQA-PassThrough-Database.accdb"

## Abre a conexão com o banco de dados
conn = odbcConnectAccess2007(databasefile);

query = "select CODE, DT_REFERENCIA, VALOR from SERIES_DEFINICAO, SERIES_DADOS_ECONOMIA where SERIES_DEFINICAO.ID = SERIES_DADOS_ECONOMIA.ID_SERIE and SERIES_DEFINICAO.CODE IN ('IPCA','IGPM','IGPDI','PTAX') and DT_REFERENCIA>#2010-01-01# and DT_REFERENCIA<#2012-01-01#";

result = sqlQuery(conn,query,stringsAsFactors=FALSE);

## Fecha a conexão com o banco de dados
odbcClose(conn);

print(result);

## Monta o dataframe
df = reshape(result,idvar="DT_REFERENCIA",timevar="CODE",direction="wide");

## Utilizando expressão regular
colnames(df) = gsub("VALOR.(.+)","\\1",colnames(df))


