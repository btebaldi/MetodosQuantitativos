## Pacotes do R
library(forecast);
library(lubridate);
library(urca);

## Biblioteca
source("../lib/BACEN-TSMS-WebService.r");

## Data Inicial
startDate = as.Date("2005-01-01");


## Códigos
codes=c(IPCA=433,IGPM=189,IGPDI=190,PTAXAvg=3698,IBCBrSA=24364);

## Configuração de Proxy
## config = use_proxy(url="corporate.prox.url", port = 80, username = "xxxxxx", password = "xxxxx", auth = "basic");
config = NULL;

## Baixa as séries
dataBACEN = TSMSGetSeries(codes, config = config, startDate=startDate);

## Monta o dataframe utilizando a função reshape():
## - A coluna "DATA" como referência para combinar as séries: idvar
## - A coluna "ID" para diferencias as séries> timevar
data = reshape(dataBACEN,idvar="DATA",timevar="ID",direction="wide");

## Ajusta no nome das colunas
colnames(data) = c("DATA",names(sort(codes)))


