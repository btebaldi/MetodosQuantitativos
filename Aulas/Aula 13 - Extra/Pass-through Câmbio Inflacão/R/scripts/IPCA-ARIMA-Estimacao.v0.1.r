## --- Bibliotecas R
library(RODBC);
library(vars);
library(urca);
library(forecast);

## --- Programa Principal


## - Carrega os dados
databasefile = "../database/MQA-PassThrough-Database.accdb"

## Abre a conex�o com o banco de dados
conn = odbcConnectAccess2007(databasefile);

## Define a Query
query = "select CODE, DT_REFERENCIA, VALOR from SERIES_DEFINICAO, SERIES_DADOS_ECONOMIA 
  where SERIES_DEFINICAO.ID = SERIES_DADOS_ECONOMIA.ID_SERIE and SERIES_DEFINICAO.CODE ='IPCA'
  order by DT_REFERENCIA";

## Executa a query
result = sqlQuery(conn,query,stringsAsFactors=FALSE);

## Fecha a conex�o com o banco de dados
odbcClose(conn);

## dataframe auxiliar
data = data.frame(Dates=result[["DT_REFERENCIA"]],IPCA=result[["VALOR"]]);

plot(data[["Dates"]],data[["IPCA"]],type='l');

## Gr�fico de Auto-correla��o
acf(data[["IPCA"]], main = "ACF IPCA")

## Auto-Correla��o parcial
pacf(data[["IPCA"]], main = "PACF IPCA")

## Modelo ARIMA
fit = auto.arima(data[["IPCA"]], max.p=3, max.q=3, seasonal=TRUE, ic = "aic");

## Resumo
summary(fit);

## Previs�o utilizando o modelo ARIMA
fit.predict = predict(fit,n.ahead = 12);

## Teste de raiz unit�ria
IPCA.df = ur.df(data[["IPCA"]],type="none",lags = 1);
summmary(IPCA.df);

## Plot da primeira diferen�a
plot(diff(data[["IPCA"]]),type="l");

## Gr�fico de Auto-correla��o
acf(diff(data[["IPCA"]]), main = "D-1 ACF IPCA")

## Auto-Correla��o parcial
pacf(diff(data[["IPCA"]]), main = "D-1 PACF IPCA")

diffIPCA.df = ur.df(diff(data[["IPCA"]]),type="none",lags = 1)
summmary(diffIPCA.df);