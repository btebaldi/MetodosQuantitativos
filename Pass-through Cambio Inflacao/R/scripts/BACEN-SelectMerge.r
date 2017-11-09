## --- Bibliotecas R
library(RODBC);

## --- Programa Principal

databasefile = "../database/MQA-PassThrough-Database.accdb"

## Abre a conexão com o banco de dados
conn = odbcConnectAccess2007(databasefile);

query = "select CODE, DT_REFERENCIA, VALOR from SERIES_DEFINICAO, SERIES_DADOS_ECONOMIA where SERIES_DEFINICAO.ID = SERIES_DADOS_ECONOMIA.ID_SERIE and SERIES_DEFINICAO.CODE IN ('IPCA','IGPM','IGPDI') and DT_REFERENCIA>#2010-01-01# and DT_REFERENCIA<#2012-01-01#";

result = sqlQuery(conn,query,stringsAsFactors=FALSE);

## Fecha a conexão com o banco de dados
odbcClose(conn);


print(result);

#result = result[-32,]

data = data.frame(DT_REFERENCIA=unique(result[['DT_REFERENCIA']]));

codes = unique(result[['CODE']]);

for (i in 1:length(codes)){
  df = result[result[["CODE"]]==codes[i],c('DT_REFERENCIA','VALOR')];
  colnames(df) = c('DT_REFERENCIA',codes[i]);
  data = merge(data,df,by='DT_REFERENCIA',all=TRUE);
}

