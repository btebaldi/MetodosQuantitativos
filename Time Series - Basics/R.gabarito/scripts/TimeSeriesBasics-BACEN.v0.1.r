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

## Converte para o objeto Time Series "ts"
## Library: lubridate: year(), month()
tsdata = ts(data[,-1],start = c(year(startDate),month(startDate)),frequency = 12);

## Forma 
print(tsdata);

## Tratamento especial para função plot()
plot(tsdata);

## Inicio
start(tsdata)
startYear = start(tsdata)[1];
startMonth = start(tsdata)[2];

## Fim
end(tsdata)
endYear = end(tsdata)[1];
endMonth = end(tsdata)[2];

## Frequencia
freq = frequency(tsdata);

## Resumo
summary(tsdata)

## time(): data como fração de ano
time(tsdata)

## cycle(): identifica os ciclos na time series
cycle(tsdata)

## -- Acessar os dados como matriz

## Acesso a uma ou mais colunas de dados
tsdata[,c("IPCA","IGPM")];

## Acesso a uma ou mais colunas de dados
tsdata[5:10,c("IPCA","IGPM")];

### -- Window

## window(...,start,end)
windata = window(tsdata, start=c(year(startDate)+3,month(startDate)), end=c(year(startDate)+6,month(startDate)));

## window(...,start,deltat)
windata = window(tsdata, start=c(year(startDate),month(startDate)), deltat=24);

## Loooping: Média Móvel ARITMÉTICA de 12 meses
dt = 12
for (t in 1:(nrow(tsdata)-dt)){
  means = colMeans(tsdata[t:(t+dt),])
  print(means);
}

## Loooping: Média Móvel GEOMÉTRICA de 12 meses
dt = 12
for (t in 1:(nrow(tsdata)-dt)){
  for (i in 1:ncol(tsdata)){
    mean = prod((tsdata[t:(t+dt),i]+1))^(1/dt);
    print(colnames(tsdata)[i])
    print(mean);
  }
}

## Trabalhando com a série de IPCA
ipca = tsdata[,"IPCA"];

## Gráfico
plot(ipca)

## Linha de tendência no tempo
abline(reg=lm(ipca~time(ipca)), col="red")

## Média ARITMÉTICA no ano (12/1)
aggregate(ipca,FUN=mean,nfrequency=1)

## Média ARITMÉTICA no trimestre (12/4)
aggregate(ipca,FUN=mean,nfrequency=4)

## Média GEOMÉTRICA no trimestre (12/4)
aggregate(ipca,FUN=function(x){prod(1+x)^(1/length(x))-1},nfrequency=4);
## Ou...
## Define a função
gmean = function(x){prod(1+x)^(1/length(x))-1};
## Aplica
aggregate(ipca,FUN=gmean,nfrequency=4);

## Boxplot: IPCA vs Ciclo
boxplot(ipca~cycle(ipca))

## Média no trimestre vs Ciclo
ipca.qtr = aggregate(ipca,FUN=gmean,nfrequency=4);
boxplot(ipca.qtr~cycle(ipca.qtr));

## Decompasição sasonal
safit = stl(ipca, s.window="period")
plot(safit)

## ACF
acf(ipca);

## PACF
pacf(ipca);

ipca.urtest = ur.df(ipca)

## Número de diffs para tornar estacionária
ndiff = ndiffs(ipca);

## Differença
ipca.diff = diff(ipca,ndiff);

## ACF
acf(ipca.diff);

## PACF
pacf(ipca.diff);

## Teste de raiz unitária
summary(ur.df(ipca.diff));

## Ajutas o arima
fit = auto.arima(ipca,max.p=5,max.q=5,max.d=2);
print(fit);

## Forecast
ipca.fcst = forecast(fit,h = 12);

## Plot do forecast
plot(ipca.fcst)


