## --- Bibliotecas R
library(RODBC);

## --- Programa Principal

databasefile = "../database/MQA-PassThrough-Database.accdb"

## Abre a conex�o com o banco de dados
conn = odbcConnectAccess2007(databasefile);

query = "select DT_REFERENCIA, VALOR from SERIES_DEFINICAO, SERIES_DADOS_ECONOMIA where SERIES_DEFINICAO.ID = SERIES_DADOS_ECONOMIA.ID_SERIE and SERIES_DEFINICAO.CODE = 'IPCA' and DT_REFERENCIA>#2010-01-01# and DT_REFERENCIA<#2012-01-01#";

result = sqlQuery(conn,query);

## Fecha a conex�o com o banco de dados
odbcClose(conn);


print(result);